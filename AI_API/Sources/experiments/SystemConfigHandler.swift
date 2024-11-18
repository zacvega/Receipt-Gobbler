import Foundation

// Configuration structs
struct SystemConfig: Codable {
    let user: UserConfig
    let paths: Paths
}

struct UserConfig: Codable {
    let username: String

}

struct Paths: Codable {
//    let log: String
    let api: String
    let prompts: String
//    let schemas: String
    let extraction_schemas: [String]
    let sql_schemas: [String]
}

enum ConfigError: Error {
    case configNotLoaded
    case sysConfigError
    case promptConfigError
    case apiConfigError
    case schemaConfigError
}

// Config class to load and hold the configuration
class Config {
    // Static variable to hold the loaded config globally
    static var shared: SystemConfig?

    static func launchConfigs(configPath: String) throws {
        do {
            guard let configFilePath = getFilePath(fileName: configPath) else {
                throw ConfigError.sysConfigError
            }
            try Config.loadConfig(from: configFilePath)
        } catch {
            print("Error loading config: \(error)")
            throw ConfigError.sysConfigError
        }

        guard let config = shared else {
            throw ConfigError.configNotLoaded
        }

        do {
            guard let promptFilePath = getFilePath(fileName: config.paths.prompts) else {
                throw ConfigError.promptConfigError
            }
            print(promptFilePath)
            try PromptHandler.loadPrompts(from: promptFilePath)
        } catch {
            print("Error loading prompts: \(error)")
            throw ConfigError.promptConfigError
        }

        var extractionSchemaFPs: [String] = []
        var sqlSchemaFPs: [String] = []
        for fn in config.paths.extraction_schemas {
            guard let fp = getFilePath(fileName: fn) else {
                throw ConfigError.apiConfigError
            }
            extractionSchemaFPs.append(fp)
        }
        for fn in config.paths.sql_schemas {
            guard let fp = getFilePath(fileName: fn) else {
                throw ConfigError.apiConfigError
            }
            sqlSchemaFPs.append(fp)
        }
        
//        do {
//            guard let schemaFilePath = getFilePath(fileName: config.paths.schemas) else {
//                throw ConfigError.schemaConfigError
//            }
//            try SchemaHandler.loadSchemaList(from: schemaFilePath)
//        } catch {
//            print("Error loading schemas: \(error)")
//            throw ConfigError.schemaConfigError
//        }
        
        do {
            try SchemaHandler.loadSchemaList(extractionSchemaFPs: extractionSchemaFPs, sqlSchemaFPs: sqlSchemaFPs)
        } catch {
            print("Error loading schemas: \(error)")
            throw ConfigError.schemaConfigError
        }

        do {
            guard let apisFilePath = getFilePath(fileName: config.paths.api) else {
                throw ConfigError.apiConfigError
            }
            try APIHandler.loadAPIInfo(from: apisFilePath)
        } catch {
            print("Error loading schemas: \(error)")
            throw ConfigError.schemaConfigError
        }
    }

    // Method to load the configuration from a file
    static func loadConfig(from path: String) throws {
        let url = URL(fileURLWithPath: path)
        
        do {
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            // Decode the JSON file into SystemConfig and store it in the shared variable
            shared = try decoder.decode(SystemConfig.self, from: data)
        } catch {
            print("Failed to load or decode the config: \(error)")
            throw error
        }
    }
}

