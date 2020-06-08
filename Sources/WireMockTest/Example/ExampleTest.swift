//
//  ExampleTest.swift
//  
//
//  Created by Wesley on 5/17/20.
//

import Foundation

class ExampleTest {
    
    let wireMock = WireMockTest()
    let wireMockApi = WireMockApi()

    func setUp() {
        do {
            try wireMock.initializeSession()
        } catch {
            fatalError(error.localizedDescription)
        }
    }

    // Update mappings using the API directly
    func test1() {
        guard let uuid = UUID(uuidString: "123"),
            var mapping = wireMockApi.getMapping(uuid, responseType: ExampleCodable.self),
            var exampleResponseObject = mapping.response.jsonBody
            else { return }
        
        exampleResponseObject.value = "newValue"
        mapping.updateResponseJson(exampleResponseObject)
        
        wireMockApi.updateMapping(mapping)
    }
    
    // Create mapping using WireMockRequest and WireMockResponse objects with stubbing
    func test2() {
        let request = WireMockRequest(method: .get, path: "/path")
        let response = WireMockResponse(response: ExampleCodable(value: "newValue"))
        
        wireMock.stub(request)
            .andReturn(response)
    }
    
    // Create mapping with stubbing
    func test3() {
        wireMock.stub("/path")
            .forHttpMethod(.get)
            .andSetStatus(200)
            .andSetFixedDelay(5)
            .andSetHeaders(["authorization": "abcde12345"])
            .andReturn(ExampleCodable(value: "newValue"))
    }
}
