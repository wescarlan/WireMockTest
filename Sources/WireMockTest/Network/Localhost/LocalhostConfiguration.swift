//
//  LocalhostConfiguration.swift
//  WireMockTest
//
//  Created by Carlan, Wesley on 5/17/20.
//  Copyright © 2020 Wesley Carlan. All rights reserved.
//

import Foundation

struct LocalhostConfiguration {
    
    let baseUrl: String
    let port: String
    
    init(baseUrl: String = "http://localhost", port: String = "8080") {
        self.baseUrl = baseUrl
        self.port = port
    }
    
    var fullUrlString: String {
        return "\(baseUrl):\(port)/"
    }
    
    var fullUrl: URL? {
        return URL(string: fullUrlString)
    }
}

extension LocalhostConfiguration {
    init(_ configuration: WireMockConfiguration) {
        self.init(port: configuration.port)
    }
}
