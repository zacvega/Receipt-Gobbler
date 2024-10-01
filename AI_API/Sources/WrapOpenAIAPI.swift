import Foundation

struct OpenAiRequest: Codable {
    var model: String
    var messages: [Message]
    var temperature: Float
    var max_tokens: Int
}

struct Message: Codable {
    var role: String
    var content: String
}

class MarshallOpenAIAPI {
    static func getOpenAIResources(userInput: String, prompt: Prompt, schema: SchemaItem, api: APIInfo) throws
    -> (urlString: String?, httpMethod: String?, headers: [String: String]?, body: Encodable?) {

        let system_message = Message(role: "system", content: prompt.prompt.prompt + schema.schemaString)
        let user_message = Message(role: "user", content: userInput)

        do {
            let request = OpenAiRequest(
                model: prompt.parameters.model,
                messages: [system_message, user_message],
                temperature: prompt.parameters.temperature,
                max_tokens: prompt.parameters.maxToken
            )
            let requestDetails: (urlString: String, httpMethod: String, headers: [String: String], body: Encodable?) = (
                urlString: api.url,
                httpMethod: "POST",
                headers: ["Authorization": "Bearer \(api.apiKey)",
                    "Content-Type": "application/json"],
                body: request
            )
            return requestDetails
        }

    }
}

/*
extra vars
frequency_penalty  -- could be useful
logit_bias -- never
logprobs  -- disagnostics
top_logprobs -- diagnoistics
max_tokens -- important
n - number of responses (chat completion)
presence_penalty -- could be useful
response_format -- json_schema for structured outs
stream -- partial messages sent
temperature -- 0 is deterministic
tools -- list of tools model can call
tool_choice -- force or prevent tool call
*/