//
//  WireMockTest.swift
//  WireMockTest
//
//  Created by Carlan, Wesley on 11/30/19.
//  Copyright © 2019 Wesley Carlan. All rights reserved.
//

import Foundation

/**
 The `WireMockTest` class is the main point of interfacing with the `WireMockTest` library.
 
 Use this class for creation of any new network stubs.
 You may use one of the `stub` methods to create new stub mappings using the WireMock admin API, and call `resetStubs` to delete any stubs that were created using the `stub` methods.
 
 - Important: In order to use the functionality that this library offers, you must call `initializeSession` on an instance of this class.
 */
open class WireMockTest {
    
    /// Set this value to enable/disable any logging output by the `WireMockTest` library.
    public static var loggingEnabled = true
    
    private let configuration: WireMockConfiguration
    private let wireMockCalls: WireMockCalls
    
    /**
     Creates a new instance of the `WireMockTest` class than can be used for network stubbing.
     
     - Parameter configuration: A `WireMockConfiguration` object specifying your local WireMock configurations.
     */
    public init(configuration: WireMockConfiguration = WireMockConfiguration()) {
        self.configuration = configuration
        self.wireMockCalls = WireMockCalls(configuration: configuration)
    }
    
    // MARK: - Initialization
    /**
     Initializes the current `WireMockTest` session by ensuring that the WireMock server is running at the specified port, and pre-fetching any stubbed mappings.
     
     - Throws: An `Error` that has occured when connecting to localhost.
     */
    open func initializeSession() throws {
        if let initializationError = wireMockCalls.initializeSession() {
            throw initializationError
        }
    }
    
    // MARK: - Stubbing
    /**
     Creates a `WireMockStub` object to be used for network stubbing on a given URL path.
     
     - Parameter path: The relative path of the request to stub.
     - Returns: A `WireMockStub` object to be used for network stubbing.
     */
    open func stub(_ path: String) -> WireMockStub {
        return WireMockStub(path: path, configuration: configuration)
    }
    
    /**
     Creates a `WireMockStub` object to be used for network stubbing with a given request.
     
     - Parameter path: The `WireMockRequest` object to be used as the request stub.
     - Returns: A `WireMockStub` object to be used for network stubbing.
     */
    open func stub(_ request: WireMockRequest) -> WireMockStub {
        return WireMockStub(request: request, configuration: configuration)
    }
    
    /**
     Deletes all new stubs that were created, and resets any existing mappings back to their original state.
     */
    open func resetStubs() {
        wireMockCalls.deleteMappings()
        wireMockCalls.resetMappings()
    }
}
