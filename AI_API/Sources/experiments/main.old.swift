import Foundation

enum ConfigPath: String {
    case configPath = "./Configs/SystemConfig.json"
}

@available(macOS 10.15.0, *)
func main_old() async {
    //print(ConfigPath.configPath.rawValue)
    let testData = try! Data(contentsOf: URL(fileURLWithPath: "./TestData/test.txt"))

    if let input = String(data: testData, encoding: .utf8) {
        let prompt = "mini_extract"
        let schema = "structured_no_alias"
        let api = "openAI"
        let result = await ExtractionAPI.extractData(inputString: input, promptString: prompt, schemaString: schema, apiString: api)
        //print(input)
        print(result ?? "Result returned nil")

    } else {
        print("Failed to convert data to string")
    }

    
}

if #available(macOS 10.15.0, *) {
    await main()
} else {
    // Fallback on earlier versions
}


/*
print(config.user.OPENAI_API_KEY)
print(config.user.username)
let key = Env.loadEnvVar(key: "MODEL")
print(key!)
*/

