//
//  ExampleTest.swift
//  
//
//  Created by Wesley on 5/17/20.
//

import Foundation

class ExampleTest {

    func setUp() {
        do {
            try WireMockTest.initializeSession()
        } catch {
            fatalError(error.localizedDescription)
        }
    }

    // Update mappings using the API directly
    func test1() {
        guard let uuid = UUID(uuidString: "123"),
            var mapping = WireMockApi.getMapping(uuid),
            var exampleResponseObject = mapping.decodeResponseJson(ExampleCodable.self)
            else { return }
        
        exampleResponseObject.value = "newValue"
        mapping.updateResponseJson(exampleResponseObject)
        
        WireMockApi.updateMapping(mapping)
    }
    
    // Create mapping using WireMockRequest and WireMockResponse objects with stubbing
    func test2() {
        let request = WireMockRequest(method: .get, path: "/path")
        let response = WireMockResponse(response: ExampleCodable(value: "newValue"))
        
        WireMockTest.stub(request)
            .andReturn(response)
    }
    
    // Create mapping with stubbing
    func test3() {
        WireMockTest.stub("/path")
            .forHttpMethod(.get)
            .andSetStatus(200)
            .andSetFixedDelay(5)
            .andSetHeaders(["authorization": "abcde12345"])
            .andReturn(ExampleCodable(value: "newValue"))
    }
}
