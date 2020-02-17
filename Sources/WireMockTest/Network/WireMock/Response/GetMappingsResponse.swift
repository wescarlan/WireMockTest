//
//  GetMappingsResponse.swift
//  WireMockTest
//
//  Created by Carlan, Wesley on 11/30/19.
//  Copyright © 2019 Wesley Carlan. All rights reserved.
//

struct GetMappingsResponse: Decodable {
    let meta: GetMappingsMetadata
    let mappings: [WireMockMapping]
}

struct GetMappingsMetadata: Decodable {
    let total: Int
}
