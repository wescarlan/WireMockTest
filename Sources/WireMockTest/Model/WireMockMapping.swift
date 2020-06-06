//
//  WireMockMapping.swift
//  WireMockTest
//
//  Created by Carlan, Wesley on 11/30/19.
//  Copyright © 2019 Wesley Carlan. All rights reserved.
//

import Foundation

struct WireMockMapping: Codable {
    let uuid: UUID
    let request: WireMockRequest
    let response: WireMockResponse
}
