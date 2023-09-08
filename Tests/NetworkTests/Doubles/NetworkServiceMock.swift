import Foundation
import NetworkInterface

struct NetworkServiceMocks {
    struct Request: NetworkRequest {
        let path = "http://buildfailedcast.com"
        let method = NetworkHTTPMethod.get
    }

    struct Response: Decodable, Equatable {
        let name: String
        let age: Int
    }

    static let invalidResponse: (Data?, URLResponse?, Error?) = (nil, nil, nil)
    static let invalidResponseData: (Data?, URLResponse?, Error?) = (nil, successHttpUrlResponse, nil)
    static let responseError: (Data?, URLResponse?, Error?) = (nil, nil, ErrorDummy())

    static var successHttpUrlResponse: HTTPURLResponse {
        HTTPURLResponse(
            url: URL(string: "http://buildfailedcast.com")!,
            statusCode: 200,
            httpVersion: nil,
            headerFields: nil
        )!
    }

    static var validResponse: (data: Data?, response: URLResponse?, error: Error?) {
        let data = """
        {
            "name": "Build Failed Podcast",
            "age": 4
        }
        """.data(using: .utf8)

        return (data, successHttpUrlResponse, nil)
    }

    struct FailedToDecodeMock: Error {}
}
