# Network

Making HTTP requests has never been so easy and decoupled.
This is an Interface Module based implementation of **URLSession** (inspired in this article [Swift Rocks - Architecting iOS apps for fast build times](https://www.runway.team/blog/how-to-improve-ios-build-times-with-modularization)).

## Implementing an HTTP Request 

### Creating NetworkRequest model

Create a structure conforming to NetworkRequest and configure the path and http method.

```swift
struct MyNewRequest: NetworkRequest {
    let path: String = "service/endpoint"
    let method: NetworkHTTPMethod = .post
}
```

The NetworkRequest API provides all the properties if you need to pass query parameters.
NetworkRequest supports **path**, **headers**, **queryParameters**, **bodyParameters**, and **httpMethod**.

### Implementing the Service/Repository

To make a request, you need to inject the Network protocol into your class, call the request method passing the request created in the previous step, and at least you need to be explicit about which type of Decodable object you want to serialize.

```swift
final class AnyService {
    private let network: Network

    init(network: Network) {
        self.network = network
    }

    func doRequest(completion: @escaping (Result<ServiceObject, Error>) -> Void) {
        network.request(MyNewRequest()) { (result: NetworkResult<ServiceObjectResponse>) in
            switch result {
            case .success(let response):
                let domainModel = response.decodedObject.map(ServiceObject.init)
                completion(.success(domainModel))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
```

The network will respond with a Result with the **decodedObject** and also with the **HTTPURLResponse** if you need to add any logic with the status code or something responded by server.

### How to test it? 

To test the requests, you could validate all the parameters that you setup your request, and protect it from future changes.

```swift
final class MyNewRequestTests: XCTestCase {
    func test_request_shouldContainsRightValues() {
        let sut = MyNewRequest()
        XCTAssertEqual(sut.path, "service/endpoint")
        XCTAssertEqual(sut.method, .post)
    }
}
```

About the service/repository you can inject the existing NetworkSpy to validate the behavior of your class, testing the success and failure scenario

```swift
final class AnyServiceTests: XCTestCase {
    private let networkSpy = NetworkSpy()
    private lazy var sut = AnyService(network: networkSpy)

    func test_doRequest_givenNetworkReturningSuccessResult_shouldReturnSuccessWithValues() throws {
        networkSpy.requestCompletionToBeReturned = NetworkResult<ServiceObjectResponse>.success(
            .init(
                decodedObject: ServiceObjectResponse(),
                httpUrlResponse: .init()
            )
        )

        var result: Result<ServiceObject, Error>?
        sut.doRequest { result = $0 }

        _ = try XCTUnwrap(try result?.get())
        XCTAssertTrue(networkSpy.requestCalled)
        XCTAssertNotNil(networkSpy.requestParametersPassed?.networkRequest as? MyNewRequest)
    }

    func test_doRequest_givenNetworkReturningFailure_withError_shouldReturnFailureWithError() throws {
        networkSpy.requestCompletionToBeReturned = NetworkResult<ServiceObjectResponse>.failure(ErrorDummy())

        var result: Result<ServiceObject, Error>?
        sut.doRequest { result = $0 }

        guard case let .failure(error) = result else {
            return XCTFail("Result should be failure with error")
        }

        XCTAssertNotNil(error as? ErrorDummy)
        XCTAssertTrue(networkSpy.requestCalled)
        XCTAssertNotNil(networkSpy.requestParametersPassed?.networkRequest as? MyNewRequest)
    }
}
```
