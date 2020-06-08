//
//  WireMockMapping.swift
//  WireMockTest
//
//  Created by Carlan, Wesley on 11/30/19.
//  Copyright © 2019 Wesley Carlan. All rights reserved.
//

import Foundation

public struct WireMockMapping<T: Codable>: Codable {
    
    public let uuid: UUID
    public var request: WireMockRequest
    public var response: WireMockResponse<T>
    
    public init(uuid: UUID? = nil, request: WireMockRequest, response: WireMockResponse<T>) {
        self.uuid = uuid ?? UUID()
        self.request = request
        self.response = response
    }
    
    public mutating func updateResponseJson(_ responseJson: T) {
        response.updateResponse(responseJson)
    }
}
