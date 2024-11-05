import Foundation

struct SchemaItem: Codable {
    let schemaName: String
    let schemaString: String
}

class SchemaHandler {
    static var extraction: [SchemaItem] = []
    static var sql: [SchemaItem] = []

    static func loadSchemaList(from directoryPath: String) throws {
        let extractionPath = directoryPath + "/Extraction"
        let directoryURL = URL(fileURLWithPath: extractionPath)
        
        do {
            let fileManager = FileManager.default
            let fileURLs = try fileManager.contentsOfDirectory(at: directoryURL, includingPropertiesForKeys: nil)
            
            for fileURL in fileURLs {
                if fileURL.pathExtension == "json" {
                    let fileName = fileURL.deletingPathExtension().lastPathComponent
                    let data = try Data(contentsOf: fileURL)
                    
                    // Convert the data into a string
                    guard let schemaString = String(data: data, encoding: .utf8) else {
                        print("Failed to read contents of file \(fileURL.lastPathComponent)")
                        continue
                    }
                    
                    // Create a new SchemaItem and append it to the list
                    let schemaItem = SchemaItem(schemaName: fileName, schemaString: schemaString)
                    print(schemaItem.schemaName)
                    extraction.append(schemaItem)
                }
            }
            
        } catch {
            print("Failed to load extraction schemas from directory: \(error)")
            throw error
        }

        let sqlPath = directoryPath + "/SQL"
        let sqlDirectoryURL = URL(fileURLWithPath: sqlPath)
        
        do {
            let fileManager = FileManager.default
            let fileURLs = try fileManager.contentsOfDirectory(at: sqlDirectoryURL, includingPropertiesForKeys: nil)
            
            for fileURL in fileURLs {
                if fileURL.pathExtension == "json" {
                    let fileName = fileURL.deletingPathExtension().lastPathComponent
                    let data = try Data(contentsOf: fileURL)
                    
                    // Convert the data into a string
                    guard let schemaString = String(data: data, encoding: .utf8) else {
                        print("Failed to read contents of file \(fileURL.lastPathComponent)")
                        continue
                    }
                    
                    // Create a new SchemaItem and append it to the list
                    let schemaItem = SchemaItem(schemaName: fileName, schemaString: schemaString)
                    print(schemaItem.schemaName)
                    sql.append(schemaItem)
                }
            }
            
        } catch {
            print("Failed to load sql schemas from directory: \(error)")
            throw error
        }
    }

    static func findSchemaItem(byName name: String, _ type: String) -> SchemaItem? {
        if type == "extraction" {
            return extraction.first { $0.schemaName == name }
        } else {
            return sql.first { $0.schemaName == name }
        }
    }
}

