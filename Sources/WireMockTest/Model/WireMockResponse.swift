//
//  WireMockResponse.swift
//  WireMockTest
//
//  Created by Carlan, Wesley on 12/2/19.
//  Copyright © 2019 Wesley Carlan. All rights reserved.
//

import Foundation

public struct WireMockResponse<T: Codable> {
    
    public var status: Int
    public var fixedDelay: Int?
    public var headers: [String: String]?
    
    public var body: String? {
        didSet {
            guard body != nil else { return }
            jsonBody = nil
            bodyFileName = nil
        }
    }
    
    public var jsonBody: T? {
        didSet {
            guard jsonBody != nil else { return }
            body = nil
            bodyFileName = nil
        }
    }
    
    public var bodyFileName: String? {
        didSet {
            guard bodyFileName != nil else { return }
            body = nil
            jsonBody = nil
        }
    }
    
    private let jsonEncoder = JSONEncoder()
    private let jsonDecoder = JSONDecoder()
    private let jsonSerializer = JSONSerialization.self
    
    // MARK: - Initializers
    public init(status: Int = 200, fixedDelay: Int? = nil, headers: [String: String]? = nil) {
        self.status = status
        self.fixedDelay = fixedDelay
        self.headers = headers
    }
    
    public init(status: Int = 200, fixedDelay: Int? = nil, headers: [String: String]? = nil, response: T) {
        self.init(status: status, fixedDelay: fixedDelay, headers: headers)
        self.jsonBody = response
    }
    
    public init(status: Int = 200, fixedDelay: Int? = nil, headers: [String: String]? = nil, response: String) {
        self.init(status: status, fixedDelay: fixedDelay, headers: headers)
        self.body = response
    }
    
    public init(status: Int = 200, fixedDelay: Int? = nil, headers: [String: String]? = nil, response: URL) {
        self.init(status: status, fixedDelay: fixedDelay, headers: headers)
        self.bodyFileName = response.absoluteString
    }
    
    // MARK: - Response Handling
    private var bodyData: Data? {
        if let json = jsonBody {
            return try? jsonSerializer.data(withJSONObject: json, options: [])
        } else if let body = body {
            return body.data(using: .utf8)
        } else {
            return nil
        }
    }
    
    public mutating func updateResponse(_ response: T) {
        self.jsonBody = response
    }
}

// MARK: - Codable -
extension WireMockResponse: Codable {
    enum CodingKeys: String, CodingKey {
        case status
        case fixedDelayMilliseconds
        case headers
        case body
        case jsonBody
        case bodyFileName
    }

    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        status = try values.decode(Int.self, forKey: .status)
        fixedDelay = try? values.decode(Int?.self, forKey: .fixedDelayMilliseconds)
        headers = try? values.decode(Dictionary?.self, forKey: .headers)
        body = try? values.decode(String?.self, forKey: .body)
        bodyFileName = try? values.decode(String?.self, forKey: .bodyFileName)
        jsonBody = try? values.decode(T?.self, forKey: .jsonBody)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(status, forKey: .status)
        try container.encode(fixedDelay, forKey: .fixedDelayMilliseconds)
        try container.encode(headers, forKey: .headers)
        try container.encode(body, forKey: .body)
        try container.encode(bodyFileName, forKey: .bodyFileName)
        try container.encode(jsonBody, forKey: .jsonBody)
    }
}
