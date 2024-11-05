import Foundation

enum ConfigPath: String {
    case configPath = "./Configs/SystemConfig.json"
}

func main() async {
    //print(ConfigPath.configPath.rawValue)
    let testData = try! Data(contentsOf: URL(fileURLWithPath: "./TestData/r1.txt"))

    if let input = String(data: testData, encoding: .utf8) {
        let prompt = "test_extract"
        let schema = "Basic_no_alias"
        let api = "openAI"
        let result = await ExtractionAPI.extractData(inputString: input, promptString: prompt, schemaString: schema, apiString: api)
        //print(input)
        print(result ?? "Result returned nil")

    } else {
        print("Failed to convert data to string")
    }

    
}

await main()  


/*
print(config.user.OPENAI_API_KEY)
print(config.user.username)
let key = Env.loadEnvVar(key: "MODEL")
print(key!)
*/
