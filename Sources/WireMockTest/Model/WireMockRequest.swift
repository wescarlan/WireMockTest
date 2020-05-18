//
//  WireMockRequest.swift
//  WireMockTest
//
//  Created by Carlan, Wesley on 12/2/19.
//  Copyright © 2019 Wesley Carlan. All rights reserved.
//

public struct WireMockRequest: Codable {
    
    var method: HTTPMethod
    var urlPath: String?
    var urlPattern: String?
    var urlPathPattern: String?
    var headers: [String: String]?
    
    init(method: HTTPMethod = .any, path: String) {
        self.method = method
        self.urlPathPattern = path
    }
}
