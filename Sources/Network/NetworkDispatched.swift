import Foundation
import NetworkInterface

final class NetworkDispatched: NetworkProtocol {
    private let decoratee: NetworkProtocol
    private let workQueue: DispatchQueueProtocol

    init(decoratee: NetworkProtocol, workQueue: DispatchQueueProtocol) {
        self.decoratee = decoratee
        self.workQueue = workQueue
    }

    func request<T: Decodable>(
        _ request: NetworkRequest,
        decoder: JSONDecoderProtocol,
        completion: @escaping (Result<NetworkSuccessResponse<T>, Error>) -> Void
    ) {
        decoratee.request(request, decoder: decoder) { [weak self] result in
            guard let self else { return }
            self.workQueue.async {
                completion(result)
            }
        }
    }
}
