//
//  LocalhostSessionManager.swift
//  WireMockTest
//
//  Created by Carlan, Wesley on 11/29/19.
//  Copyright © 2019 Wesley Carlan. All rights reserved.
//

import Foundation
import HttpUtils

class LocalhostSessionManager {
    
    // MARK: - Typealiases
    typealias LocalhostSuccess = (Data) -> Void
    typealias LocalhostFailure = (Error?) -> Void
    
    // MARK: - Shared URL Configuration
    /// The Localhost configuration object with information where the localhost server is running
    private var configuration: LocalhostConfiguration
    
    /// A reference to the shared URLSession instance
    private var urlSession: URLSession {
        return URLSession.shared
    }
    
    // MARK: - Initializers
    init(configuration: LocalhostConfiguration) {
        self.configuration = configuration
    }
    
    // MARK: - Request Creation
    /// Get the full URL by appending a path string to the base URL
    private func url(path: String) -> URL? {
        return configuration.fullUrl?.appendingPathComponent(path)
    }
    
    /// Get the URLRequest object for a given URL and HTTP method
    private func urlRequest(url: URL, method: HTTP.Method, body: Data? = nil) -> URLRequest {
        var request = URLRequest(url: url)
        request.setMethod(method)
        request.setContentTypeHeader(.application(.json))
        request.httpBody = body
        return request
    }
    
    // MARK: - Response Parsing
    /// Handle the DataTask response with optional LocalhostSuccess and LocalhostFailure closures
    private class func handleResponse(data: Data?, response: URLResponse?, error: Error?, success: LocalhostSuccess?, failure: LocalhostFailure?) {
        guard error == nil else {
            failure?(error)
            return
        }
        
        guard let httpResponse = response as? HTTPURLResponse else {
            failure?(LocalhostError.invalidResponse(urlResponse: response))
            return
        }
        
        guard HTTP.StatusCode.successRange.contains(httpResponse.statusCode) else {
            failure?(LocalhostError.localhostServer(statusCode: httpResponse.statusCode))
            return
        }
        
        guard let data = data else {
            failure?(LocalhostError.parsing)
            return
        }
        
        success?(data)
    }
    
    // MARK: - GET Request
    /// Execute a GET request
    func get(path: String, success: LocalhostSuccess?, failure: LocalhostFailure?) {
        guard let url = url(path: path) else {
            failure?(LocalhostError.invalidUrl(url: configuration.fullUrlString))
            return
        }
        
        let task = urlSession.dataTask(with: url) { (data, response, error) in
            LocalhostSessionManager.handleResponse(
                data: data,
                response: response,
                error: error,
                success: success,
                failure: failure)
        }
        
        task.resume()
    }
    
    // MARK: - POST Request
    /// Execute a POST request
    func post(path: String, bodyData: Data?, success: LocalhostSuccess?, failure: LocalhostFailure?) {
        guard let url = url(path: path) else {
            failure?(LocalhostError.invalidUrl(url: configuration.fullUrlString))
            return
        }
        
        let request = urlRequest(url: url, method: .post, body: bodyData)
        
        let task = urlSession.dataTask(with: request) { (data, response, error) in
            LocalhostSessionManager.handleResponse(
                data: data,
                response: response,
                error: error,
                success: success,
                failure: failure)
        }
        
        task.resume()
    }
    
    // MARK: - PUT Request
    /// Execute a PUT request
    func put(path: String, bodyData: Data?, success: LocalhostSuccess?, failure: LocalhostFailure?) {
        guard let url = url(path: path) else {
            failure?(LocalhostError.invalidUrl(url: configuration.fullUrlString))
            return
        }
        
        let request = urlRequest(url: url, method: .put, body: bodyData)
        
        let task = urlSession.dataTask(with: request) { (data, response, error) in
            LocalhostSessionManager.handleResponse(
                data: data,
                response: response,
                error: error,
                success: success,
                failure: failure)
        }
        
        task.resume()
    }
    
    // MARK: - DELETE Request
    /// Execute a DELETE request
    func delete(path: String, success: LocalhostSuccess?, failure: LocalhostFailure?) {
        guard let url = url(path: path) else {
            failure?(LocalhostError.invalidUrl(url: configuration.fullUrlString))
            return
        }
        
        let request = urlRequest(url: url, method: .delete)
        
        let task = urlSession.dataTask(with: request) { (data, response, error) in
            LocalhostSessionManager.handleResponse(
                data: data,
                response: response,
                error: error,
                success: success,
                failure: failure)
        }
        
        task.resume()
    }
}
