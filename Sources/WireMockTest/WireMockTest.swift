//
//  WireMockTest.swift
//  WireMockTest
//
//  Created by Carlan, Wesley on 11/30/19.
//  Copyright © 2019 Wesley Carlan. All rights reserved.
//

public class WireMockTest {
    
    private static var sharedInstance = WireMockTest()
    
    private var configuration: WireMockConfiguration = WireMockConfiguration()
    
    class var configuration: WireMockConfiguration {
        get { return sharedInstance.configuration }
        set { sharedInstance.configuration = newValue }
    }
    
    class var mappings: [WireMockMapping] {
        return WireMockCalls.getMappings()
    }
    
    class func initializeSession() throws {
        if let initializationError = WireMockCalls.initializeSession() {
            throw initializationError
        }
    }
    
    class func createMapping(_ mapping: WireMockMapping) {
        WireMockCalls.createMapping(mapping)
    }
    
    class func updateMapping(_ mapping: WireMockMapping) {
        WireMockCalls.updateMapping(mapping)
    }
    
    class func resetMappings() {
        WireMockCalls.resetMappings()
    }
}
