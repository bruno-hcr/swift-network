import Foundation

public protocol URLSessionProtocol {
    func dataTask(
        with request: URLRequest,
        completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void
    )
}

extension URLSession: URLSessionProtocol {
    public func dataTask(
        with request: URLRequest,
        completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void
    ) {
        dataTask(with: request, completionHandler: completionHandler).resume()
    }
}
