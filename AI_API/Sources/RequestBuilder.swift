import Foundation

#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

enum RequestError: Error {
    case missingAPIKey
    case invalidURL
    case configNotLoaded
}

class RequestBuilder {
    // Builds and validates the request for any given API endpoint and headers
    static func buildRequest(
        urlString: String,
        httpMethod: String = "POST",
        headers: [String: String] = [:],
        body: Encodable? = nil
    ) throws -> URLRequest {
        // Ensure the URL is valid
        guard let url = URL(string: urlString) else {
            throw RequestError.invalidURL
        }

        var request = URLRequest(url: url)
        request.httpMethod = httpMethod

        // Add headers
        for (key, value) in headers {
            request.addValue(value, forHTTPHeaderField: key)
        }

        // If there's a body, encode it as JSON
        if let body = body {
            let encoder = JSONEncoder()
            request.httpBody = try encoder.encode(body)
        }

        //print("Request setup complete.")  // Debug message
        return request
    }
}