//
//  WireMockStub.swift
//  
//
//  Created by Wesley on 5/17/20.
//

import Foundation

open class WireMockStub {
    
    private var request: WireMockRequest
    private var responseStatus = 200
    private var responseDelay: Int?
    private var responseHeaders: [String: String]?
    
    // MARK: - Initializers
    public init(path: String) {
        request = WireMockRequest(path: path)
    }
    
    public init(request: WireMockRequest) {
        self.request = request
    }
    
    // MARK: - Request Setters
    open func forHttpMethod(_ method: HTTPMethod) -> WireMockStub {
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
    open func andReturn() -> WireMockMapping {
        let wireMockResponse = WireMockResponse(status: responseStatus, fixedDelay: responseDelay, headers: responseHeaders)
        return andReturn(wireMockResponse)
    }
    
    @discardableResult
    open func andReturn<T: Encodable>(_ response: T) -> WireMockMapping {
        var wireMockResponse = WireMockResponse(status: responseStatus, fixedDelay: responseDelay, headers: responseHeaders)
        do {
            let responseData = try JSONEncoder().encode(response)
            let responseString = String(data: responseData, encoding: .utf8)
            wireMockResponse.body = responseString
        } catch {
            if WireMockTest.configuration.loggingEnabled {
                print(error.localizedDescription)
            }
        }
        return andReturn(wireMockResponse)
    }
    
    @discardableResult
    open func andReturn(_ response: [String: Any]) -> WireMockMapping {
        var wireMockResponse = WireMockResponse(status: responseStatus, fixedDelay: responseDelay, headers: responseHeaders)
        wireMockResponse.jsonBody = response
        return andReturn(wireMockResponse)
    }
    
    @discardableResult
    open func andReturn(_ response: String) -> WireMockMapping {
        var wireMockResponse = WireMockResponse(status: responseStatus, fixedDelay: responseDelay, headers: responseHeaders)
        wireMockResponse.body = response
        return andReturn(wireMockResponse)
    }
    
    @discardableResult
    open func andReturn(_ response: URL) -> WireMockMapping {
        var wireMockResponse = WireMockResponse(status: responseStatus, fixedDelay: responseDelay, headers: responseHeaders)
        wireMockResponse.bodyFileName = response.absoluteString
        return andReturn(wireMockResponse)
    }
    
    @discardableResult
    open func andReturn(_ response: WireMockResponse) -> WireMockMapping {
        let mapping = WireMockMapping(request: request, response: response)
        WireMockApi.createMapping(mapping)
        return mapping
    }
}
