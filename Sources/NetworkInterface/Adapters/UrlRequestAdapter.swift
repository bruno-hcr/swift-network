import Foundation

extension NetworkConfiguration where Self: UrlRequestAdapter {
    public func toRequest() throws -> URLRequest {
        guard var urlPathComponents = URLComponents(string: path) else {
            throw NetworkRequestError.invalidPathComponents
        }

        if let queryParameters {
            urlPathComponents.queryItems = queryParameters.map {
                URLQueryItem(name: $0.key, value: $0.value)
            }
        }

        guard let baseUrl = URL(string: baseUrl.urlString),
              let url = urlPathComponents.url(relativeTo: baseUrl) else {
            throw NetworkRequestError.invalidUrl
        }

        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = method.rawValue


        if let headers {
            for header in headers {
                urlRequest.setValue(header.value, forHTTPHeaderField: header.key)
            }
        }

        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")

        if let bodyParameters = self.bodyParameters {
            urlRequest.httpBody = try JSONSerialization.data(withJSONObject: bodyParameters)
        }

        return urlRequest
    }
}

