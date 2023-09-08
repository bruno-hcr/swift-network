import Foundation
import NetworkInterface

final class NetworkProtocolSpy: NetworkProtocol {

    private (set) var requestParametersPassed: (networkRequest: NetworkRequest, decoder: JSONDecoderProtocol)?
    private (set) var requestCalled: Bool = false
    var requestCompletionToBeReturned: Any?

    func request<T>(
        _ networkRequest: NetworkRequest,
        decoder: JSONDecoderProtocol,
        completion: @escaping (NetworkResult<T>) -> Void
    ) where T: Decodable {
        requestCalled = true
        requestParametersPassed = (networkRequest, decoder)
        if let requestCompletionToBeReturned = requestCompletionToBeReturned as? NetworkResult<T> {
            completion(requestCompletionToBeReturned)
        }
    }
}
