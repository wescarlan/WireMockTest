//
//  WireMockStub.swift
//  
//
//  Created by Wesley on 5/17/20.
//

import Foundation
import HttpUtils

/**
 A `WireMockStub` object can be used for creating new `WireMockMapping` objects for use by the WireMock admin API.
 
 The `WireMockStub` class uses the builder pattern for stubbing the request and response.
 
 # Request Stubbing Methods:
 - `forHttpMethod`
 
 # Response Stubbing Methods:
 - `withResponseStatus`
 - `withResponseDelay`
 - `withResponseHeaders`
 
 All instances of the class must call one of the `andReturn` methods in order for the request to be properly mocked. Calling `andReturn` will make a subsequent request to the WireMock admin API and automaticaly create the stub mapping.
 */
open class WireMockStub {
    
    private var request: WireMockRequest
    private var responseStatus = 200
    private var responseDelay: Int?
    private var responseHeaders: [String: String]?
    
    private let configuration: WireMockConfiguration
    private let wireMockCalls: WireMockCalls
    
    // MARK: - Initializers
    /**
     Creates a new `WireMockStub` object that can be used for stubbing network requests.
     
     The `WireMockStub` object should be used to create a new `WireMockMapping` object by calling one of the `andReturn` methods.
     
     - Parameter request: The `WireMockRequest` to be used for network stubbing.
     - Parameter configuration: A `WireMockConfiguration` object specifying your local WireMock configurations.
     */
    public init(request: WireMockRequest, configuration: WireMockConfiguration) {
        self.request = request
        self.configuration = configuration
        self.wireMockCalls = WireMockCalls(configuration: configuration)
    }
    
    /**
     Creates a new `WireMockStub` object that can be used for stubbing network requests.
     
     The `WireMockStub` object should used to create a new `WireMockMapping` object by calling one of the `andReturn` methods.
     
     - Parameter path: The path of the request to be used for network stubbing.
     - Parameter configuration: A `WireMockConfiguration` object specifying your local WireMock configurations.
     */
    public convenience init(path: String, configuration: WireMockConfiguration) {
        self.init(request: WireMockRequest(path: path), configuration: configuration)
    }
    
    // MARK: - Request Setters
    /**
     Sets the HTTP method used for the request stub.
     
     If not set, defaults to `ANY`.
     
     - Parameter method: The HTTP method to use for the request.
     - Returns: The updated `WireMockStub` object.
     */
    open func forHttpMethod(_ method: HTTP.Method) -> WireMockStub {
        request.method = method
        return self
    }
    
    // MARK: - Response Setters
    /**
     Sets the response's HTTP status code for the stubbed network request.
     
     If not set, defaults to `200`.
     
     - Parameter status: The status code to be used in the response.
     - Returns: The updated `WireMockStub` object.
     */
    open func withResponseStatus(_ status: Int) -> WireMockStub {
        responseStatus = status
        return self
    }
    
    /**
     Sets the response delay time in seconds for the stubbed network request.
     
     If not set, there will be no delay in receiving the response.
     
     - Parameter delay: The delay time in seconds to be used with the response.
     - Returns: The updated `WireMockStub` object.
     */
    open func withResponseDelay(_ delay: Int) -> WireMockStub {
        responseDelay = delay
        return self
    }
    
    /**
     Sets the response headers for the stubbed network request.
     
     If not set, the response will use WireMock's default headers.
     
     - Parameter headers: A dictionary of header key-value pairs to use for the response.
     - Returns: The updated `WireMockStub` object.
     */
    open func withResponseHeaders(_ headers: [String: String]) -> WireMockStub {
        responseHeaders = headers
        return self
    }
    
    // MARK: - Return Response
    /**
     Uses the WireMock admin API to create a new `WireMockMapping` for the stubbed request and returns a response whose body conforms to the `Encodable` protocol.
     
     This currently only allows for responses that can be encoded using a `JSONEncoder`.
     
     - Parameter response: The response body to return by the stubbed request.
     - Returns: The new `WireMockMapping` object that corresponds to the stubbed request.
     */
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
    
    /**
     Uses the WireMock admin API to create a new `WireMockMapping` for the stubbed request and returns a response with the given string as its response body.
     
     - Parameter response: The response body string to return by the stubbed request.
     - Returns: The new `WireMockMapping` object that corresponds to the stubbed request.
     */
    @discardableResult
    open func andReturn(_ response: String) -> WireMockMapping<String> {
        var wireMockResponse = WireMockResponse<String>(status: responseStatus, fixedDelay: responseDelay, headers: responseHeaders)
        wireMockResponse.body = response
        return andReturn(wireMockResponse)
    }
    
    /**
     Uses the WireMock admin API to create a new `WireMockMapping` for the stubbed request and returns a response whose body is at the given file path.
     
     The URL must be a valid file path that directs to a WireMock response body file. The file must also be included in the app bundle in order to find it at runtime.
     
     - Parameter response: The URL of the response body file to return by the stubbed request.
     - Returns: The new `WireMockMapping` object that corresponds to the stubbed request.
     */
    @discardableResult
    open func andReturn(_ response: URL) -> WireMockMapping<String> {
        var wireMockResponse = WireMockResponse<String>(status: responseStatus, fixedDelay: responseDelay, headers: responseHeaders)
        wireMockResponse.bodyFileName = response.absoluteString
        return andReturn(wireMockResponse)
    }
    
    /**
     Uses the WireMock admin API to create a new `WireMockMapping` for the stubbed request and returns the given `WireMockResponse` object.
     
     - Parameter response: The `WireMockResponse` object to return by the stubbed request.
     - Returns: The new `WireMockMapping` object that corresponds to the stubbed request.
     */
    @discardableResult
    open func andReturn<T: Codable>(_ response: WireMockResponse<T>) -> WireMockMapping<T> {
        let mapping = WireMockMapping<T>(request: request, response: response)
        wireMockCalls.createMapping(mapping)
        return mapping
    }
}
