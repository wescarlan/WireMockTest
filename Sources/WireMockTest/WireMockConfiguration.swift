//
//  WireMockConfiguration.swift
//  WireMockTest
//
//  Created by Carlan, Wesley on 11/29/19.
//  Copyright © 2019 Wesley Carlan. All rights reserved.
//

public struct WireMockConfiguration {
    
    var port: String
    var loggingEnabled: Bool
    
    init(port: String = "8080", loggingEnabled: Bool = true) {
        self.port = port
        self.loggingEnabled = loggingEnabled
    }
}
