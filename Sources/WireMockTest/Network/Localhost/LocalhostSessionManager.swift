//
//  LocalhostSessionManager.swift
//  WireMockTest
//
//  Created by Carlan, Wesley on 11/29/19.
//  Copyright © 2019 Wesley Carlan. All rights reserved.
//

import Foundation

class LocalhostSessionManager {
    
    // MARK: - Typealiases
    typealias LocalhostSuccess = (Data) -> Void
    typealias LocalhostFailure = (Error?) -> Void
    
    // MARK: - Shared Instance
    /// The shared LocalHostSessionManager instance. Use this to
    static let shared = LocalhostSessionManager()
    
    // MARK: - Shared URL Configuration
    private let localhostBaseUrl = "http://localhost"
    
    /// The WireMock configuration object with information where the localhost server is running
    private var configuration: WireMockConfiguration
    
    /// The computed WireMock base URL string consisting of the localhost URL combined with the port number
    private var baseUrlString: String {
        return "\(localhostBaseUrl):\(configuration.port)/"
    }
    
    /// The computed WireMock base URL consisting of the localhost URL combined with the port number
    private var baseUrl: URL? {
        return URL(string: baseUrlString)
    }
    
    /// A reference to the shared URLSession instance
    private var urlSession: URLSession {
        return URLSession.shared
    }
    
    // MARK: - Initializers
    convenience init() {
        self.init(configuration: WireMockConfiguration())
    }
    
    init(configuration: WireMockConfiguration) {
        self.configuration = configuration
    }
    
    // MARK: - Request Creation
    /// Get the full URL by appending a path string to the base URL
    private func url(path: String) -> URL? {
        return baseUrl?.appendingPathComponent(path)
    }
    
    /// Get the URLRequest object for a given URL and HTTPMethod
    private func urlRequest(url: URL, method: HTTPMethod, body: Data? = nil) -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.setValue(HTTPHeader.Value.applicationJson, forHTTPHeaderField: HTTPHeader.Field.contentType)
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
            failure?(LocalhostError(type: .invalidResponse(urlResponse: response)))
            return
        }
        
        guard HTTPStatusCode.successRange.contains(httpResponse.statusCode) else {
            failure?(LocalhostError(type: .wireMockServer(statusCode: httpResponse.statusCode)))
            return
        }
        
        guard let data = data else {
            failure?(LocalhostError(type: .parsing))
            return
        }
        
        success?(data)
    }
    
    // MARK: - GET
    /// Execute a GET request
    func get(path: String, success: LocalhostSuccess?, failure: LocalhostFailure?) {
        guard let url = url(path: path) else {
            failure?(LocalhostError(type: .invalidUrl(url: baseUrlString)))
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
    
    // MARK: - POST
    /// Execute a POST request
    func post(path: String, bodyData: Data?, success: LocalhostSuccess?, failure: LocalhostFailure?) {
        guard let url = url(path: path) else {
            failure?(LocalhostError(type: .invalidUrl(url: baseUrlString)))
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
    
    // MARK: - PUT
    /// Execute a PUT request
    func put(path: String, bodyData: Data?, success: LocalhostSuccess?, failure: LocalhostFailure?) {
        guard let url = url(path: path) else {
            failure?(LocalhostError(type: .invalidUrl(url: baseUrlString)))
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
}
