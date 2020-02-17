//
//  WireMockConfiguration.swift
//  WireMockTest
//
//  Created by Carlan, Wesley on 11/29/19.
//  Copyright © 2019 Wesley Carlan. All rights reserved.
//

struct WireMockConfiguration {
    
    var port: String
    var loggingEnabled: Bool
    
    init() {
        self.port = "8080"
        self.loggingEnabled = true
    }
}
