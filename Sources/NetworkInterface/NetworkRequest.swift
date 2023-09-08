import Foundation

public enum NetworkHTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}

public enum NetworkBaseUrl: CaseIterable {
    case prod
    case staging
    case homolog

    var urlString: String {
        switch self {
        case .prod:
            return UrlProvider.prod
        case .staging:
            return UrlProvider.staging
        case .homolog:
            return UrlProvider.homolog
        }
    }
}

public protocol UrlRequestAdapter {
    func toRequest() throws -> URLRequest
}

public protocol NetworkConfiguration {
    var baseUrl: NetworkBaseUrl { get }
    var path: String { get }
    var headers: [String: String]? { get }
    var queryParameters: [String: String]? { get }
    var bodyParameters: [String: Any]? { get }
    var method: NetworkHTTPMethod { get }
    var shouldUseCommonHeaders: Bool { get }
    var shouldUseCommonQueryParameters: Bool { get }
}

public extension NetworkConfiguration {
    var baseUrl: NetworkBaseUrl { .prod }
    var headers: [String: String]? { nil }
    var queryParameters: [String: String]? { nil }
    var bodyParameters: [String: Any]? { nil }
    var shouldUseCommonHeaders: Bool { true }
    var shouldUseCommonQueryParameters: Bool { true }
}

public typealias NetworkRequest = NetworkConfiguration & UrlRequestAdapter
