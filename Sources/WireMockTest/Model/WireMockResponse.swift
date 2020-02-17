//
//  WireMockResponse.swift
//  WireMockTest
//
//  Created by Carlan, Wesley on 12/2/19.
//  Copyright © 2019 Wesley Carlan. All rights reserved.
//

import Foundation

struct WireMockResponse: Codable {
    let status: Int
    var fixedDelay: Int?
    var headers: [String: String]?
    var body: String?
    var jsonBody: [String: Any]?
    var bodyFileName: String?
    
    enum CodingKeys: String, CodingKey {
        case status
        case fixedDelayMilliseconds
        case headers
        case body
        case jsonBody
        case bodyFileName
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        status = try values.decode(Int.self, forKey: .status)
        fixedDelay = try? values.decode(Int?.self, forKey: .fixedDelayMilliseconds)
        headers = try? values.decode(Dictionary?.self, forKey: .headers)
        body = try? values.decode(String?.self, forKey: .body)
        bodyFileName = try? values.decode(String?.self, forKey: .bodyFileName)
        
        let jsonBodyString = try? values.decode(String?.self, forKey: .jsonBody)
        if let jsonBodyData = jsonBodyString?.data(using: .utf8) {
            jsonBody = try? JSONSerialization.jsonObject(with: jsonBodyData, options: []) as? [String: Any]
        }
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(status, forKey: .status)
        try container.encode(fixedDelay, forKey: .fixedDelayMilliseconds)
        try container.encode(headers, forKey: .headers)
        try container.encode(body, forKey: .body)
        try container.encode(bodyFileName, forKey: .bodyFileName)
        
        if let jsonBody = jsonBody, let jsonBodyData = try? JSONSerialization.data(withJSONObject: jsonBody, options: []) {
            let jsonBodyString = String(data: jsonBodyData, encoding: .utf8)
            try container.encode(jsonBodyString, forKey: .jsonBody)
        }
    }
}
