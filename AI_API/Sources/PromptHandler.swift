import Foundation

struct PromptCollection: Codable {
    let promptList: [Prompt]
}

struct Prompt: Codable {
    let name: String
    let task: String
    let apiService: String
    let parameters: Params
    let prompt: PromptString
}

struct Params: Codable {
    let minSize: Int
    let maxSize: Int
    let model: String
    let maxToken: Int
    let temperature: Float
}

struct PromptString: Codable {
    let prompt: String
}

class PromptHandler {
    static var shared: PromptCollection?

    static func loadPrompts(from path: String) throws {
        let url = URL(fileURLWithPath: path)

        do {
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            shared = try decoder.decode(PromptCollection.self, from: data)
        } catch {
            throw error
        }
    }

    // Function to search for a prompt by name
    static func findPromptByName(_ name: String) -> Prompt? {
        guard let collection = shared else {
            print("No prompt collection loaded.")
            return nil
        }
        
        // Search the collection's prompt list for the matching prompt by name
        if let prompt = collection.promptList.first(where: { $0.name == name }) {
            return prompt
        }

        print("Prompt with name \(name) not found.")
        return nil
    }
}