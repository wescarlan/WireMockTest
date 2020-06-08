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
    
    public init(configuration: WireMockConfiguration = WireMockConfiguration()) {
        self.configuration = configuration
        self.wireMockCalls = WireMockCalls(configuration: configuration)
    }
    
    // MARK: - Endpoints
    /// Get all WireMock mappings
    open func getMappings() -> [WireMockMapping<String>] {
        return wireMockCalls.getMappings()
    }
    
    /// Get a WireMock mapping by its UUID
    open func getMapping<T: Codable>(_ uuid: UUID, responseType: T.Type) -> WireMockMapping<T>? {
        return wireMockCalls.getMapping(uuid: uuid, responseType: responseType)
    }
    
    /// Create a new WireMock mapping
    open func createMapping<T: Codable>(_ mapping: WireMockMapping<T>) {
        wireMockCalls.createMapping(mapping)
    }
    
    /// Update an existing WireMock mapping
    open func updateMapping<T: Codable>(_ mapping: WireMockMapping<T>) {
        wireMockCalls.updateMapping(mapping)
    }
    
    /// Reset all WireMock mappings
    open func resetMappings() {
        wireMockCalls.resetMappings()
    }
}
