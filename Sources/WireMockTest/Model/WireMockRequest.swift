//
//  WireMockRequest.swift
//  WireMockTest
//
//  Created by Carlan, Wesley on 12/2/19.
//  Copyright © 2019 Wesley Carlan. All rights reserved.
//

public struct WireMockRequest: Codable {
    
    public var method: HTTPMethod
    public var url: String?
    public var urlPath: String?
    public var urlPattern: String?
    public var urlPathPattern: String?
    public var headers: [String: String]?
    
    public init(method: HTTPMethod = .any, path: String) {
        self.method = method
        self.urlPathPattern = path
    }
}
