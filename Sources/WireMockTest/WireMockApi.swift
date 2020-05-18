//
//  WireMockApi.swift
//  WireMockTest
//
//  Created by Wesley on 5/17/20.
//  Copyright © 2020 Wesley Carlan. All rights reserved.
//

import Foundation

open class WireMockApi {
    
    /// Get all WireMock mappings
    open class func getMappings() -> [WireMockMapping] {
        return WireMockCalls.getMappings()
    }
    
    /// Get a WireMock mapping by its UUID
    open class func getMapping(_ uuid: UUID) -> WireMockMapping? {
        return WireMockCalls.getMapping(uuid: uuid)
    }
    
    /// Create a new WireMock mapping
    open class func createMapping(_ mapping: WireMockMapping) {
        WireMockCalls.createMapping(mapping)
    }
    
    /// Update an existing WireMock mapping
    open class func updateMapping(_ mapping: WireMockMapping) {
        WireMockCalls.updateMapping(mapping)
    }
    
    /// Reset all WireMock mappings
    open class func resetMappings() {
        WireMockCalls.resetMappings()
    }
}
