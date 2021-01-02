//
//  WireMockTest.swift
//  WireMockTest
//
//  Created by Carlan, Wesley on 11/30/19.
//  Copyright © 2019 Wesley Carlan. All rights reserved.
//

import Foundation

open class WireMockTest {
    
    public static var loggingEnabled = true
    private let configuration: WireMockConfiguration
    private let wireMockCalls: WireMockCalls
    
    public init(configuration: WireMockConfiguration = WireMockConfiguration()) {
        self.configuration = configuration
        self.wireMockCalls = WireMockCalls(configuration: configuration)
    }
    
    // MARK: - Initialization
    open func initializeSession() throws {
        if let initializationError = wireMockCalls.initializeSession() {
            throw initializationError
        }
    }
    
    // MARK: - Stubbing
    open func stub(_ path: String) -> WireMockStub {
        return WireMockStub(path: path, configuration: configuration)
    }
    
    open func stub(_ request: WireMockRequest) -> WireMockStub {
        return WireMockStub(request: request, configuration: configuration)
    }
    
    open func resetStubs() {
        wireMockCalls.deleteMappings()
        wireMockCalls.resetMappings()
    }
}
