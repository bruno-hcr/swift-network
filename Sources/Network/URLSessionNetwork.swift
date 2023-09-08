import Foundation
import NetworkInterface

public final class URLSessionNetwork {
    private let session: URLSessionProtocol

    public init(session: URLSessionProtocol) {
        self.session = session
    }
}

extension URLSessionNetwork: NetworkProtocol {
    public func request<T: Decodable>(
        _ networkRequest: NetworkRequest,
        decoder: JSONDecoderProtocol,
        completion: @escaping (Result<NetworkSuccessResponse<T>, Error>) -> Void
    ) {
        do {
            let urlRequest = try networkRequest.toRequest()

            session.dataTask(with: urlRequest) { data, response, error in
                if let error {
                    completion(.failure(error)); return
                }

                guard let httpURLResponse = response as? HTTPURLResponse else {
                    completion(.failure(NetworkError.invalidHttpURLResponse)); return
                }

                guard let data else {
                    completion(.failure(NetworkError.invalidResponseData)); return
                }

                do {
                    let decoded = try decoder.decode(T.self, from: data)
                    completion(
                        .success(.init(decodedObject: decoded, httpUrlResponse: httpURLResponse))
                    )
                } catch {
                    completion(.failure(error))
                }
            }
        } catch {
            completion(.failure(error))
        }
    }
}
