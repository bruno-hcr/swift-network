import Foundation
import XCTest

@testable import NetworkInterface

final class URLRequestAdapterTests: XCTestCase {
    func test_toRequest_givenAllRequestValues_shouldReturnUrlRequest_withRightValues() throws {
        let expectedHttpMethod = NetworkHTTPMethod.get

        let sut = Request.Fixture(
            path: "users/me",
            headers: ["header_1": "value_1", "header_2": "value_2"],
            queryParameters: ["query_1": "value_1"],
            bodyParameters: ["body_1": "value_1", "body_2": 10, "body_3": false],
            method: expectedHttpMethod
        )

        let result = try sut.toRequest()

        XCTAssertEqual(result.url?.absoluteString, "https://prod.com/users/me?query_1=value_1")
        XCTAssertEqual(result.allHTTPHeaderFields, ["Content-Type": "application/json", "header_2": "value_2", "header_1": "value_1"])
        XCTAssertNotNil(result.httpBody)
        XCTAssertEqual(result.httpMethod, expectedHttpMethod.rawValue)
    }
}
