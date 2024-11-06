import Foundation

enum ConfigPath: String {
    case configPath = "./Configs/SystemConfig.json"
}

func main() async {
    //print(ConfigPath.configPath.rawValue)
    let testData = try! Data(contentsOf: URL(fileURLWithPath: "./TestData/image1.JPG"))

    if let image = imageFromData(imageData) {
        if let text = extractText(from: image) {
            print("Extracted text:\n\(text)")
                if let input = String(data: text, encoding: .utf8) {
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
    } else {
        print("Failed to convert Data to UIImage.")
    }    
}

await main()  


/*
print(config.user.OPENAI_API_KEY)
print(config.user.username)
let key = Env.loadEnvVar(key: "MODEL")
print(key!)
*/
