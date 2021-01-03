# WireMockTest

WireMockTest is a Swift package that allows for simple interfacing with the WireMock admin API.

**Features:**

* Methods for interacting directly with the WireMock admin API
* Easy stubbing of new request mappings

**System Requirements:**

* Xcode 11+
* Swift 5.1+


## Installation

### Swift Package Manager

Add the following to your Package.swift file:

```swift
dependencies: [
    .package(url: "https://github.com/wescarlan/WireMockTest", from: "0.1.1")
]
```


## Usage

### Importing

```swift
import WireMockTest
```

---


### Initializing WireMockTest

In order to have a reference to all stub mappings at runtime and to validate the WireMock localhost connection, you first need to initialize the `WireMockTest` instance.

In your test case class, add the following:

```swift
import WireMockTest
import XCTest

class MyTestCase: XCTestCase {
    
    var wireMock: WireMockTest!

    override func setUpWithError() throws {
        // Configure WireMockTest with the appropriate WireMock server information.
        let configuration = WireMockConfiguration(port: "8080")
        wireMock = WireMockTest(configuration: configuration)
        
        // Initialize the WireMockTest session.
        try wireMock.initializeSession()
        
        // Perform any necessary app setup and launch the app.
        let app = XCUIApplication()
        app.launch()
    }
}
```

If you are also going to be using the WireMock admin API directly, add the following:

```swift
import WireMockTest
import XCTest

class MyTestCase: XCTestCase {
    
    var wireMock: WireMockTest!
    var wireMockApi: WireMockApi!

    override func setUpWithError() throws {
        // Configure WireMockTest and WireMockApi with the appropriate WireMock server information.
        let configuration = WireMockConfiguration(port: "8080")
        wireMock = WireMockTest(configuration: configuration)
        wireMockApi = WireMockApi(configuration: configuration)
        
        // Initialize the WireMockTest session.
        try wireMock.initializeSession()
        
        // Perform any necessary app setup and launch the app.
        let app = XCUIApplication()
        app.launch()
    }
}
```

---


### Request Stubbing

The `WireMockTest` instance gives you easy access to creating new WireMock stub mappings.

For the purpose of these examples, refer to the following example response class:

```swift
struct ExampleCodable: Codable {
    var value: String
}
```

<br/>

**Method 1**

Provide the relative URL path of the request to stub and a Codable object to return in the response:

```swift
wireMock.stub("/path")
    .forHttpMethod(.get)
    .withResponseStatus(200)
    .withResponseDelay(5)
    .withResponseHeaders(["authorization": "abcde12345"])
    .andReturn(ExampleCodable(value: "newValue"))
```

<br/>

**Method 2**

Provide an instance of WireMockRequest of the request to stub and WireMockResponse for the stubbed response:

```swift
let request = WireMockRequest(method: .get, path: "/path")
let response = WireMockResponse(response: ExampleCodable(value: "newValue"))

wireMock.stub(request).andReturn(response)
```

<br/>

**Reset stubbed mappings**

If you need to provide new stubs for a request you have already stubbed, or no longer need to stub the request, you may reset all stubs.

This will delete any new mappings you have created as well as reset any existing mappings:

```swift
wireMock.resetStubs()
```

---


### WireMock Admin API

Use the `WireMockApi` to interface directly with the WireMock server that is running on your localhost.

For the purpose of these examples, refer to the following example response class:

```swift
struct ExampleCodable: Codable {
    var value: String
}
```

<br/>

**Getting stubbed mappings**

Get all stubbed mappings:

```swift
let mappings = wireMockApi.getMappings()
```

Get a stubbed mapping by its UUID:

```swift
let uuid = UUID("7b017740-4d5a-11eb-ae93-0242ac130002")!
let mapping = wireMockApi.getMapping(uuid, responseType: ExampleCodable.self)
```

<br/>

**Creating stubbed mappings**

Create a stub mapping with `WireMockRequest` and `WireMockResponse` objects:

```swift
let request = WireMockRequest(method: .get, path: "/path")
let response = WireMockResponse(response: ExampleCodable(value: "value"))
let mapping = WireMockMapping(request: request, response: response)
wireMockApi.createMapping(mapping)
```

<br/>

**Updating stubbed mappings**

Update a stubbed mapping with `WireMockRequest` and `WireMockResponse` objects:

```swift
let uuid = UUID("7b017740-4d5a-11eb-ae93-0242ac130002")!
var mapping = wireMockApi.getMapping(uuid, responseType: ExampleCodable.self)!
var exampleCodableObject = mapping.response.jsonBody!

exampleCodableObject.value = "newValue"
mapping.updateResponseJson(exampleCodableObject)
wireMockApi.updateMapping(mapping)
```

<br/>

**Resetting stubbed mappings**

Reset all stubbed mappings:

```swift
wireMockApi.resetMappings()
```

<br/>

**Deleting stubbed mappings**

Delete all stubbed mappings:

```swift
wireMockApi.deleteMappings()
```

Delete a stubbed mapping by its UUID:
```swift
let uuid = UUID("7b017740-4d5a-11eb-ae93-0242ac130002")!
wireMockApi.deleteMapping(uuid)
```


## Example Project

Check out this example project for a more in-depth look into how the WireMockTest framework can be used to write UI tests:
[wescarlan/WireMockTestExample](https://github.com/wescarlan/WireMockTestExample)


## License

HTTPUtils is released under the [Apache 2.0 License](LICENSE)
