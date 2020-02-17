//
//  WireMockRequest.swift
//  WireMockTest
//
//  Created by Carlan, Wesley on 12/2/19.
//  Copyright © 2019 Wesley Carlan. All rights reserved.
//

import Foundation

struct WireMockRequest: Codable {
    let method: HTTPMethod
    var urlPath: String?
    var urlPattern: String?
    var urlPathPattern: String?
    var headers: [String: String]?
}
