//
//  LocalhostError.swift
//  WireMockTest
//
//  Created by Carlan, Wesley on 11/30/19.
//  Copyright © 2019 Wesley Carlan. All rights reserved.
//

import Foundation

struct LocalhostError: Error {
    enum ErrorType {
        case invalidUrl(url: String)
        case invalidResponse(urlResponse: URLResponse?)
        case wireMockServer(statusCode: Int)
        case parsing
    }
    
    let type: ErrorType
    
    var localizedDescription: String {
        switch type {
        case .invalidUrl(let url):
            return "Localhost Error - Invalid URL: \(url)"
        case .invalidResponse(let urlResponse):
            return "Localhost Error - Invalid Response: \(urlResponse?.description ?? "")"
        case .wireMockServer(let statusCode):
            return "Localhost Error - WireMock Server Error: \(statusCode)"
        case .parsing:
            return "Localhost Error - Failed to Parse Response"
        }
    }
}
