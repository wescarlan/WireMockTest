//
//  WireMockStub.swift
//  
//
//  Created by Wesley on 5/17/20.
//

import Foundation
import HttpUtils

open class WireMockStub {
    
    private var request: WireMockRequest
    private var responseStatus = 200
    private var responseDelay: Int?
    private var responseHeaders: [String: String]?
    
    private let configuration: WireMockConfiguration
    private let wireMockCalls: WireMockCalls
    
    // MARK: - Initializers
    public init(request: WireMockRequest, configuration: WireMockConfiguration) {
        self.request = request
        self.configuration = configuration
        self.wireMockCalls = WireMockCalls(configuration: configuration)
    }
    
    public convenience init(path: String, configuration: WireMockConfiguration) {
        self.init(request: WireMockRequest(path: path), configuration: configuration)
    }
    
    // MARK: - Request Setters
    open func forHttpMethod(_ method: HTTP.Method) -> WireMockStub {
        request.method = method
        return self
    }
    
    // MARK: - Response Setters
    open func andSetStatus(_ status: Int) -> WireMockStub {
        responseStatus = status
        return self
    }
    
    open func andSetFixedDelay(_ delay: Int) -> WireMockStub {
        responseDelay = delay
        return self
    }
    
    open func andSetHeaders(_ headers: [String: String]) -> WireMockStub {
        responseHeaders = headers
        return self
    }
    
    // MARK: - Return Response
    @discardableResult
    open func andReturn<T: Codable>() -> WireMockMapping<T> {
        let wireMockResponse = WireMockResponse<T>(status: responseStatus, fixedDelay: responseDelay, headers: responseHeaders)
        return andReturn(wireMockResponse)
    }
    
    @discardableResult
    open func andReturn<T: Encodable>(_ response: T) -> WireMockMapping<T> {
        var wireMockResponse = WireMockResponse<T>(status: responseStatus, fixedDelay: responseDelay, headers: responseHeaders)
        do {
            let responseData = try JSONEncoder().encode(response)
            let responseString = String(data: responseData, encoding: .utf8)
            wireMockResponse.body = responseString
        } catch {
            if WireMockTest.loggingEnabled {
                print(error.localizedDescription)
            }
        }
        return andReturn(wireMockResponse)
    }
    
    @discardableResult
    open func andReturn(_ response: String) -> WireMockMapping<String> {
        var wireMockResponse = WireMockResponse<String>(status: responseStatus, fixedDelay: responseDelay, headers: responseHeaders)
        wireMockResponse.body = response
        return andReturn(wireMockResponse)
    }
    
    @discardableResult
    open func andReturn(_ response: URL) -> WireMockMapping<String> {
        var wireMockResponse = WireMockResponse<String>(status: responseStatus, fixedDelay: responseDelay, headers: responseHeaders)
        wireMockResponse.bodyFileName = response.absoluteString
        return andReturn(wireMockResponse)
    }
    
    @discardableResult
    open func andReturn<T: Codable>(_ response: WireMockResponse<T>) -> WireMockMapping<T> {
        let mapping = WireMockMapping<T>(request: request, response: response)
        wireMockCalls.createMapping(mapping)
        return mapping
    }
}
