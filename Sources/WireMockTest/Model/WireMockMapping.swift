//
//  WireMockMapping.swift
//  WireMockTest
//
//  Created by Carlan, Wesley on 11/30/19.
//  Copyright © 2019 Wesley Carlan. All rights reserved.
//

import Foundation

public struct WireMockMapping: Codable {
    
    public let uuid: UUID
    public var request: WireMockRequest
    public var response: WireMockResponse
    
    public init(uuid: UUID? = nil, request: WireMockRequest, response: WireMockResponse) {
        self.uuid = uuid ?? UUID()
        self.request = request
        self.response = response
    }
    
    public func decodeResponseJson<T: Decodable>(_ responseClass: T.Type) -> T? {
        return response.decodeResponse(responseClass)
    }
    
    public mutating func updateResponseJson<T: Encodable>(_ responseJson: T) {
        response.updateResponse(responseJson)
    }
}
