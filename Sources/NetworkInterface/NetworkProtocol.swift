import Foundation

public struct NetworkSuccessResponse<T: Decodable> {
    public let decodedObject: T
    public let httpUrlResponse: HTTPURLResponse

    public init(decodedObject: T, httpUrlResponse: HTTPURLResponse) {
        self.decodedObject = decodedObject
        self.httpUrlResponse = httpUrlResponse
    }
}

public typealias NetworkResult<T: Decodable> = Result<NetworkSuccessResponse<T>, Error>
public typealias NetworkVoidResult = Result<NetworkSuccessResponse<VoidResponse>, Error>

public struct VoidResponse: Codable {}

public protocol NetworkProtocol {
    func request<T: Decodable>(
        _ networkRequest: NetworkRequest,
        decoder: JSONDecoderProtocol,
        completion: @escaping (NetworkResult<T>) -> Void
    )
}

public extension NetworkProtocol {
    func request<T: Decodable>(_ networkRequest: NetworkRequest, completion: @escaping (NetworkResult<T>) -> Void) {
        request(networkRequest, decoder: JSONDecoder(), completion: completion)
    }
}
