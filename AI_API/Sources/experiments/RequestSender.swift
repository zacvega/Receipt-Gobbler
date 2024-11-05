import Foundation

#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

class RequestSender {
    // Sends the request and handles the response
    static func sendRequest(_ request: URLRequest) async throws -> Data {
        let (data, response) = try await URLSession.shared.data(for: request)

        // Check if the response is an HTTP response
        guard let httpResponse = response as? HTTPURLResponse else {
            throw URLError(.badServerResponse)
        }

        //print("Received HTTP response: \(httpResponse.statusCode)")  // Debug message

        // If successful, return the response data, otherwise throw an error
        if httpResponse.statusCode == 200 {
            return data
        } else {
            // Handle non-200 status codes
            if let responseString = String(data: data, encoding: .utf8) {
                print("HTTP Error: \(httpResponse.statusCode), Response Body: \(responseString)")
            }
            throw URLError(.badServerResponse)
        }
    }
}