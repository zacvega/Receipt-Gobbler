import Foundation

// Define the structure for the schemaList
struct SchemaList: Codable {
    let schemaList: [SchemaItem]
}

struct SchemaItem: Codable {
    let schemaName: String
    let schemaString: String
}

class SchemaHandler {
    static var shared: SchemaList?

    static func loadSchemaList(from path: String) throws {
        let url = URL(fileURLWithPath: path)
        
        do {
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            // Decode the JSON file into SystemConfig and store it in the shared variable
            shared = try decoder.decode(SchemaList.self, from: data)
        } catch {
            print("Failed to load or decode the config: \(error)")
            throw error
        }
    }

    static func findSchemaItem(byName name: String) -> SchemaItem? {
        guard let schemaList = shared else {
            print("Schema list not loaded.")
            return nil
        }
        
        // Search for the schema with the specified name
        return schemaList.schemaList.first { $0.schemaName == name }
    }
}
