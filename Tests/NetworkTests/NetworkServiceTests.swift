import Foundation
import NetworkInterface
import XCTest

@testable import Network

final class UrlSessionNetworkTests: XCTestCase {
    private let sessionStub = URLSessionProtocolStub()
    private let decoderStub = JSONDecoderProtocolStub()
    private lazy var sut = URLSessionNetwork(session: sessionStub)

    func test_request_givenValidResponse_withValidDecodedObject_shouldReturnSuccess_withValues() throws {
        let expectedDecodedObject = NetworkServiceMocks.Response(name: "", age: 0)

        let expectedResponse = NetworkServiceMocks.validResponse
        sessionStub.dataTaskToBeReturned = expectedResponse
        decoderStub.decodeToBeReturned = expectedDecodedObject

        let request = NetworkServiceMocks.Request()

        var result: NetworkResult<NetworkServiceMocks.Response>?
        sut.request(request, decoder: decoderStub) { result = $0 }

        let unwrappedResult = try XCTUnwrap(result)
        guard case .success(let response) = unwrappedResult else {
            return XCTFail("Response should be success")
        }

        XCTAssertEqual(response.decodedObject, expectedDecodedObject)
        XCTAssertEqual(response.httpUrlResponse, expectedResponse.response)
    }

    func test_request_givenInvalidResponse_withValidDecodedObject_shouldReturnFailure_withError() throws {
        let expectedDecodedObject = NetworkServiceMocks.Response(name: "", age: 0)

        let expectedResponse = NetworkServiceMocks.invalidResponse
        sessionStub.dataTaskToBeReturned = expectedResponse
        decoderStub.decodeToBeReturned = expectedDecodedObject

        let request = NetworkServiceMocks.Request()

        var result: NetworkResult<NetworkServiceMocks.Response>?
        sut.request(request, decoder: decoderStub) { result = $0 }

        let unwrappedResult = try XCTUnwrap(result)
        guard case .failure(let error) = unwrappedResult else {
            return XCTFail("Response should be failure")
        }

        let networkError = try XCTUnwrap(error as? NetworkError)
        XCTAssertEqual(networkError, .invalidHttpURLResponse)
    }

    func test_request_givenInvalidDataResponse_withValidDecodedObject_shouldReturnFailure_withError() throws {
        let expectedDecodedObject = NetworkServiceMocks.Response(name: "", age: 0)

        let expectedResponse = NetworkServiceMocks.invalidResponseData
        sessionStub.dataTaskToBeReturned = expectedResponse
        decoderStub.decodeToBeReturned = expectedDecodedObject

        let request = NetworkServiceMocks.Request()

        var result: NetworkResult<NetworkServiceMocks.Response>?
        sut.request(request, decoder: decoderStub) { result = $0 }

        let unwrappedResult = try XCTUnwrap(result)
        guard case .failure(let error) = unwrappedResult else {
            return XCTFail("Response should be failure")
        }

        let networkError = try XCTUnwrap(error as? NetworkError)
        XCTAssertEqual(networkError, .invalidResponseData)
    }

    func test_request_givenErrorResponse_withValidDecodedObject_shouldReturnFailure_withError() throws {
        let expectedDecodedObject = NetworkServiceMocks.Response(name: "", age: 0)

        let expectedResponse = NetworkServiceMocks.responseError
        sessionStub.dataTaskToBeReturned = expectedResponse
        decoderStub.decodeToBeReturned = expectedDecodedObject

        let request = NetworkServiceMocks.Request()

        var result: NetworkResult<NetworkServiceMocks.Response>?
        sut.request(request, decoder: decoderStub) { result = $0 }

        let unwrappedResult = try XCTUnwrap(result)
        guard case .failure(let error) = unwrappedResult else {
            return XCTFail("Response should be failure")
        }

        XCTAssertNotNil(error as? ErrorDummy)
    }

    func test_request_givenValidResponse_withInvalidObject_shouldReturnFailure_withDecodeError() throws {
        let expectedResponse = NetworkServiceMocks.validResponse
        sessionStub.dataTaskToBeReturned = expectedResponse
        decoderStub.decodeToBeReturned = ErrorDummy()

        let request = NetworkServiceMocks.Request()

        var result: NetworkResult<NetworkServiceMocks.Response>?
        sut.request(request, decoder: decoderStub) { result = $0 }

        let unwrappedResult = try XCTUnwrap(result)
        guard case .failure(let error) = unwrappedResult else {
            return XCTFail("Response should be failure")
        }

        XCTAssertNotNil(error as? NetworkServiceMocks.FailedToDecodeMock)
    }
}
