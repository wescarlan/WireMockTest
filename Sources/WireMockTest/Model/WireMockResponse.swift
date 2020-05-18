//
//  WireMockResponse.swift
//  WireMockTest
//
//  Created by Carlan, Wesley on 12/2/19.
//  Copyright © 2019 Wesley Carlan. All rights reserved.
//

import Foundation

public struct WireMockResponse {
    
    var status: Int
    var fixedDelay: Int?
    var headers: [String: String]?
    
    var body: String? {
        didSet {
            guard body != nil else { return }
            jsonBody = nil
            bodyFileName = nil
        }
    }
    
    var jsonBody: [String: Any]? {
        didSet {
            guard jsonBody != nil else { return }
            body = nil
            bodyFileName = nil
        }
    }
    
    var bodyFileName: String? {
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
    init(status: Int = 200, fixedDelay: Int? = nil, headers: [String: String]? = nil) {
        self.status = status
        self.fixedDelay = fixedDelay
        self.headers = headers
    }
    
    init<T: Encodable>(status: Int = 200, fixedDelay: Int? = nil, headers: [String: String]? = nil, response: T) {
        self.init(status: status, fixedDelay: fixedDelay, headers: headers)
        
        do {
            let responseData = try jsonEncoder.encode(response)
            let json = try jsonSerializer.jsonObject(with: responseData, options: []) as? [String: Any]
            self.jsonBody = json
        } catch {
            if WireMockTest.loggingEnabled {
                print(error.localizedDescription)
            }
        }
    }
    
    init(status: Int = 200, fixedDelay: Int? = nil, headers: [String: String]? = nil, response: [String: Any]) {
        self.init(status: status, fixedDelay: fixedDelay, headers: headers)
        self.jsonBody = response
    }
    
    init(status: Int = 200, fixedDelay: Int? = nil, headers: [String: String]? = nil, response: String) {
        self.init(status: status, fixedDelay: fixedDelay, headers: headers)
        self.body = response
    }
    
    init(status: Int = 200, fixedDelay: Int? = nil, headers: [String: String]? = nil, response: URL) {
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
    
    func decodeResponse<T: Decodable>(_ responseClass: T.Type) -> T? {
        guard let data = bodyData else { return nil }
        
        do {
            return try jsonDecoder.decode(responseClass, from: data)
        } catch {
            if WireMockTest.loggingEnabled {
                print(error.localizedDescription)
            }
            return nil
        }
    }
    
    mutating func updateResponse<T: Encodable>(_ response: T) {
        do {
            let data = try jsonEncoder.encode(response)
            let json = try jsonSerializer.jsonObject(with: data, options: []) as? [String: Any]
            self.jsonBody = json
        } catch {
            if WireMockTest.loggingEnabled {
                print(error.localizedDescription)
            }
        }
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
        
        let jsonBodyString = try? values.decode(String?.self, forKey: .jsonBody)
        if let jsonBodyData = jsonBodyString?.data(using: .utf8) {
            jsonBody = try? JSONSerialization.jsonObject(with: jsonBodyData, options: []) as? [String: Any]
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(status, forKey: .status)
        try container.encode(fixedDelay, forKey: .fixedDelayMilliseconds)
        try container.encode(headers, forKey: .headers)
        try container.encode(body, forKey: .body)
        try container.encode(bodyFileName, forKey: .bodyFileName)
        
        if let jsonBody = jsonBody, let jsonBodyData = try? jsonSerializer.data(withJSONObject: jsonBody, options: []) {
            let jsonBodyString = String(data: jsonBodyData, encoding: .utf8)
            try container.encode(jsonBodyString, forKey: .jsonBody)
        }
    }
}
