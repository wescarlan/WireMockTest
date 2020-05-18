//
//  WireMockApi.swift
//  WireMockTest
//
//  Created by Wesley on 5/17/20.
//  Copyright © 2020 Wesley Carlan. All rights reserved.
//

import Foundation

open class WireMockApi {
    
    private let configuration: WireMockConfiguration
    private let wireMockCalls: WireMockCalls
    
    init(configuration: WireMockConfiguration = WireMockConfiguration()) {
        self.configuration = configuration
        self.wireMockCalls = WireMockCalls(configuration: configuration)
    }
    
    // MARK: - Endpoints
    /// Get all WireMock mappings
    open func getMappings() -> [WireMockMapping] {
        return wireMockCalls.getMappings()
    }
    
    /// Get a WireMock mapping by its UUID
    open func getMapping(_ uuid: UUID) -> WireMockMapping? {
        return wireMockCalls.getMapping(uuid: uuid)
    }
    
    /// Create a new WireMock mapping
    open func createMapping(_ mapping: WireMockMapping) {
        wireMockCalls.createMapping(mapping)
    }
    
    /// Update an existing WireMock mapping
    open func updateMapping(_ mapping: WireMockMapping) {
        wireMockCalls.updateMapping(mapping)
    }
    
    /// Reset all WireMock mappings
    open func resetMappings() {
        wireMockCalls.resetMappings()
    }
}
