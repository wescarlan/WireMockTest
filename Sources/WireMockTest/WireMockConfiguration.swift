//
//  WireMockConfiguration.swift
//  WireMockTest
//
//  Created by Carlan, Wesley on 11/29/19.
//  Copyright © 2019 Wesley Carlan. All rights reserved.
//

/**
 A `WireMockConfiguration` is used to represent the local configuration of your WireMock server.
 */
public struct WireMockConfiguration {
    
    var port: String
    
    /**
     Creates an instance of `WireMockConfiguration` that can be used to initilize the `WireMockTest` library.
     
     - Parameter port: The port number your WireMock server is running on. Defaults to `8080`.
     */
    public init(port: String = "8080") {
        self.port = port
    }
}
