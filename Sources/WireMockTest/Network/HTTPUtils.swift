//
//  HTTPUtils.swift
//  WireMockTest
//
//  Created by Carlan, Wesley on 11/30/19.
//  Copyright © 2019 Wesley Carlan. All rights reserved.
//

enum HTTPMethod: String, Codable {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}

struct HTTPHeader {
    struct Field {
        static let contentType = "Content-Type"
    }
    
    struct Value {
        static let applicationJson = "application/json"
    }
}

struct HTTPStatusCode {
    static let informationRange = 100...199
    static let successRange = 200...299
    static let redirectRange = 300...399
    static let clientRange = 400...499
    static let internalServerRange = 500...599
}
