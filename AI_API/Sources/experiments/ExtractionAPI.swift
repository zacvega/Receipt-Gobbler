import Foundation

class ConfigPath {
//    case configPath = "./Configs/SystemConfig.json"
    static var configPath = Bundle.main.path(forResource: "SystemConfig", ofType: "json")!
}

enum MainExtractionError: Error {
    case promptError
    case schemaError
    case apiError
    case inputValidationError
    case textError
    case configLaunchError
}

class ExtractionAPI {
    static func extractData(inputString: String, promptString: String, schemaString: String, apiString: String) async -> String? {

            do {

                try Config.launchConfigs(configPath: ConfigPath.configPath)
                

                guard let api = APIHandler.findAPIByName(apiString) else {
                   throw MainExtractionError.apiError
                }
                
                guard let prompt = PromptHandler.findPromptByName(promptString) else {
                    throw MainExtractionError.promptError
                }
                
                guard let schema = SchemaHandler.findSchemaItem(byName: schemaString, "extraction") else {
                    print("schema not found")
                    throw MainExtractionError.schemaError
                }
                

                guard validateParams(prompt:prompt, schema:schema, api:api) else {
                    throw MainExtractionError.inputValidationError
                }

                try TextPreprocessor.validateText(input: inputString, params: prompt.parameters)

                

                let (urlString, httpMethod, headers, body) = try MarshallOpenAIAPI.getOpenAIResources(userInput: inputString, prompt: prompt, schema: schema, api: api) // needs to be generic 
                let request = try RequestBuilder.buildRequest(urlString: urlString!, httpMethod: httpMethod!, headers: headers!, body: body!)
                let response = try await RequestSender.sendRequest(request)
                let return_message = UnwrapOpenAIAPI.decodeOpenAIResponse(data: response)  // needs to be generic 

                return return_message
            } catch {
                print(error)
                return nil
            }
    }

    static func validateParams(prompt: Prompt, schema: SchemaItem, api: APIInfo) -> Bool {        
        // Check for API and prompt compatibility
        if api.name != prompt.apiService && api.name != "generic" {
            print("Mismatch between API and prompt")
            return false
        }
        
        // Validate prompt task type
        if prompt.task != "test" && prompt.task != "text_extraction" {
            print("Incorrect prompt type")
            return false
        }
        
        // If all validations pass, return true
        return true
    }

}
