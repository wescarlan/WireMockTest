//
//  LocalhostError.swift
//  WireMockTest
//
//  Created by Carlan, Wesley on 11/30/19.
//  Copyright © 2019 Wesley Carlan. All rights reserved.
//

import Foundation

enum LocalhostError: Error {
    case invalidUrl(url: String)
    case invalidResponse(urlResponse: URLResponse?)
    case localhostServer(statusCode: Int)
    case parsing
    
    var localizedDescription: String {
        switch self {
        case .invalidUrl(let url):
            return "Localhost Error - Invalid URL: \(url)"
        case .invalidResponse(let urlResponse):
            return "Localhost Error - Invalid Response: \(urlResponse?.description ?? "nil")"
        case .localhostServer(let statusCode):
            return "Localhost Error - WireMock Server Error: \(statusCode)"
        case .parsing:
            return "Localhost Error - Failed to Parse Response"
        }
    }
}
