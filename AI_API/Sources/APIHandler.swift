import Foundation

struct APIList: Codable {
    let apiList: [APIInfo]
}

struct APIInfo: Codable {
    let name: String
    let url: String
    let apiKey: String
}

class APIHandler {
    static var shared: APIList?

    static func loadAPIInfo(from path: String) throws {
        let url = URL(fileURLWithPath: path)

        do {
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            // Decode the JSON file into SystemConfig and store it in the shared variable
            shared = try decoder.decode(APIList.self, from: data)
        } catch {
            print("Failed to load or decode the APIInfo: \(error)")
            throw error
        }
    }

    static func findAPIByName(_ name: String) -> APIInfo? {
        guard let collection = shared else {
            print("No api collection loaded.")
            return nil
        }
        
        // Search the collection's prompt list for the matching prompt by name
        if let data = collection.apiList.first(where: { $0.name == name }) {
            return data
        }

        print("API with name \(name) not found.")
        return nil
    }
}