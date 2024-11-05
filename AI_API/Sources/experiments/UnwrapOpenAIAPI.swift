import Foundation

// Define a struct to hold the relevant part of the OpenAI API response
struct OpenAIMessageResponse: Codable {
    let choices: [Choice]

    struct Choice: Codable {
        let message: Message
    }

    struct Message: Codable {
        let role: String
        let content: String
    }
}

class UnwrapOpenAIAPI {
    static func decodeOpenAIResponse(data: Data) -> String? {
        do {
            // Decode the JSON response into OpenAIMessageResponse struct
            let decodedResponse = try JSONDecoder().decode(OpenAIMessageResponse.self, from: data)
            // Return the content of the first message, if available
            return decodedResponse.choices.first?.message.content
        } catch {
            print("Error decoding response: \(error.localizedDescription)")
            return nil
        }
    }
}