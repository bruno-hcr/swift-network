import Foundation
import XCTest

@testable import NetworkInterface

final class NetworkBaseUrlTests: XCTestCase {
    func test_urlString_shouldReturnRightValues() {
        XCTAssertEqual(NetworkBaseUrl.prod.urlString, "https://prod.com")
        XCTAssertEqual(NetworkBaseUrl.staging.urlString, "https://staging.com")
        XCTAssertEqual(NetworkBaseUrl.homolog.urlString, "https://homolog.com")
        XCTAssertEqual(NetworkBaseUrl.allCases.count, 3)
    }
}
