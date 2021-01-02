//
//  WireMockApi.swift
//  WireMockTest
//
//  Created by Wesley on 5/17/20.
//  Copyright © 2020 Wesley Carlan. All rights reserved.
//

import Foundation

/**
 A `WireMockApi` object is the main point of interfacing with the WireMock admin API.
 
 Use a `WireMockApi` reference for getting, creating, updating, and deleting stub mappings.
 */
open class WireMockApi {
    
    private let configuration: WireMockConfiguration
    private let wireMockCalls: WireMockCalls
    
    /**
     Creates an instance of `WireMockApi` to be used for interfacing with the WireMock admin API.
     
     - Parameter configuration: A `WireMockConfiguration` object specifying your local WireMock configurations.
     */
    public init(configuration: WireMockConfiguration = WireMockConfiguration()) {
        self.configuration = configuration
        self.wireMockCalls = WireMockCalls(configuration: configuration)
    }
    
    // MARK: - Endpoints
    /**
     Gets a list of all WireMock stub mappings.
     
     - Returns: An array of all `WireMockMapping` objects.
     */
    open func getMappings() -> [WireMockMapping<Data>] {
        return wireMockCalls.getMappings()
    }
    
    /**
     Gets a WireMock stub mapping by its UUID.
     
     - Parameter uuid: The UUID of the stub mapping.
     - Parameter responseType: The `Codable` response object type that is returned by the stub mapping.
     - Returns: The corresponding `WireMockMapping` object.
     */
    open func getMapping<T: Codable>(_ uuid: UUID, responseType: T.Type) -> WireMockMapping<T>? {
        return wireMockCalls.getMapping(uuid: uuid, responseType: responseType)
    }
    
    /**
     Creates a new WireMock stub mapping using the given `WireMockMapping` object.
     
     - Parameter mapping: The `WireMockMapping` object used to create the stub mapping.
     */
    open func createMapping<T: Codable>(_ mapping: WireMockMapping<T>) {
        wireMockCalls.createMapping(mapping)
    }
    
    /**
     Updates an existing WireMock stub mapping.
     
     - Parameter mapping: The `WireMockMapping` object used for updating the stub mapping.
     */
    open func updateMapping<T: Codable>(_ mapping: WireMockMapping<T>) {
        wireMockCalls.updateMapping(mapping)
    }
    
    /**
     Resets all WireMock stub mappings back to their original state.
     */
    open func resetMappings() {
        wireMockCalls.resetMappings()
    }
    
    /**
     Deletes all WireMock stub mappings.
     */
    open func deleteMappings() {
        wireMockCalls.deleteMappings()
    }
    
    /**
     Delete an existing WireMock stub mapping by its UUID.
     
     - Parameter uuid: The UUID of the stub mapping to delete.
     */
    open func deleteMapping(_ uuid: UUID) {
        wireMockCalls.deleteMapping(uuid: uuid)
    }
}
