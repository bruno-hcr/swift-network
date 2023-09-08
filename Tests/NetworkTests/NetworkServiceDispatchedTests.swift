import Foundation
import NetworkInterface
import XCTest

@testable import Network

final class NetworkDispatchedTests: XCTestCase {
    private let networkStub = NetworkProtocolStub()
    private let workQueueSpy = DispatchQueueProtocolSpy()

    private lazy var sut = NetworkDispatched(
        decoratee: networkStub,
        workQueue: workQueueSpy
    )

    func test_request_givenSuccessNetworkResponse_shouldCallWorkQueue_withValues() throws {
        let expectedDecodedObject = NetworkServiceMocks.Response(name: "", age: 0)
        let expectedResponse = NetworkServiceMocks.successHttpUrlResponse

        networkStub.requestCompletionToBeReturned = NetworkResult<NetworkServiceMocks.Response>.success(
            .init(decodedObject: expectedDecodedObject, httpUrlResponse: expectedResponse)
        )

        var result: NetworkResult<NetworkServiceMocks.Response>?
        sut.request(NetworkServiceMocks.Request()) { result = $0 }

        let unwrappedResult = try XCTUnwrap(result)
        guard case .success(let response) = unwrappedResult else {
            return XCTFail("Response should be success")
        }

        XCTAssertEqual(workQueueSpy.asyncCalledCount, 1)
        XCTAssertEqual(response.decodedObject, expectedDecodedObject)
        XCTAssertEqual(response.httpUrlResponse, expectedResponse)
    }

    func test_request_givenFailureNetworkResponse_shouldCallWorkQueue_withValues() throws {
        networkStub.requestCompletionToBeReturned = NetworkResult<NetworkServiceMocks.Response>.failure(ErrorDummy())

        var result: NetworkResult<NetworkServiceMocks.Response>?
        sut.request(NetworkServiceMocks.Request()) { result = $0 }

        let unwrappedResult = try XCTUnwrap(result)
        guard case .failure(let error) = unwrappedResult else {
            return XCTFail("Response should be failure")
        }

        XCTAssertEqual(workQueueSpy.asyncCalledCount, 1)
        XCTAssertNotNil(error as? ErrorDummy)
    }
}
