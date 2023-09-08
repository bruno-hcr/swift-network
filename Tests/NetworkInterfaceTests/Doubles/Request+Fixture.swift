import NetworkInterface

enum Request {
    struct Fixture: NetworkRequest {
        let path: String
        let headers: [String: String]?
        let queryParameters: [String: String]?
        let bodyParameters: [String: Any]?
        let method: NetworkHTTPMethod

        init(
            path: String = "",
            headers: [String: String]? = nil,
            queryParameters: [String: String]? = nil,
            bodyParameters: [String: Any]? = nil,
            method: NetworkHTTPMethod = .get
        ) {
            self.path = path
            self.headers = headers
            self.queryParameters = queryParameters
            self.bodyParameters = bodyParameters
            self.method = method
        }
    }
}
