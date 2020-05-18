//
//  WireMockTest.swift
//  WireMockTest
//
//  Created by Carlan, Wesley on 11/30/19.
//  Copyright © 2019 Wesley Carlan. All rights reserved.
//

import Foundation

public class WireMockTest {
    
    private static var shared = WireMockTest()
    
    // MARK: - Configuration
    private var configuration: WireMockConfiguration = WireMockConfiguration()
    
    class var configuration: WireMockConfiguration {
        get { return shared.configuration }
        set { shared.configuration = newValue }
    }
    
    // MARK: - Initialization
    class func initializeSession() throws {
        if let initializationError = WireMockCalls.initializeSession() {
            throw initializationError
        }
    }
    
    // MARK: - Stubbing
    class func stub(_ path: String) -> WireMockStub {
        return WireMockStub(path: path)
    }
    
    class func stub(_ request: WireMockRequest) -> WireMockStub {
        return WireMockStub(request: request)
    }
    
    class func resetStubs() {
        WireMockApi.resetMappings()
    }
}
