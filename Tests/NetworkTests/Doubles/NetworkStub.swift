import Foundation
import NetworkInterface

final class NetworkProtocolStub: NetworkProtocol {
    
    private(set) var requestCalledCount = 0
    private var requestCalled: Bool { requestCalledCount > 0 }
    var requestCompletionToBeReturned: Any?

    func request<T: Decodable>(
        _ networkRequest: NetworkRequest,
        decoder: JSONDecoderProtocol,
        completion: @escaping (NetworkResult<T>) -> Void
    ) {
        requestCalledCount += 1
        if let result = requestCompletionToBeReturned as? NetworkResult<T> {
            completion(result)
        } else {
            assertionFailure("Failed in casting type of request to be returned in NetworkResult generic value.")
        }
    }
}
