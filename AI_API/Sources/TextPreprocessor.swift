import Foundation

// function checks wraps OCR / other input vector text
// preconditions

// Define custom error types
enum TextWrapperError: Error {
    case stringTooShort(minSize: Int)
    case stringTooLong(maxSize: Int)
}

enum TextConstants: Double {
    case WORD_TOKEN_ESTIMATE = 1.3
}

class TextPreprocessor {

    // Function to validate the text
    static func validateText(input: String, params: Params) throws {

        let token_length = estimateTokenCount(text: input)

        if token_length < params.minSize {
            throw TextWrapperError.stringTooShort(minSize: params.minSize)
        }

        // Check if the text is too long
        if token_length > params.maxSize {
            throw TextWrapperError.stringTooLong(maxSize: params.maxSize)
        }                
    }

    static func estimateTokenCount(text: String) -> Int {
        // Break the text into words using whitespace and punctuation as separators
        let words = text.components(separatedBy: CharacterSet.whitespacesAndNewlines.union(.punctuationCharacters))
            .filter { !$0.isEmpty }

        // Estimate tokens based on the number of words and average token length per word
        let averageTokensPerWord = TextConstants.WORD_TOKEN_ESTIMATE.rawValue
        let tokenCountEstimate = Double(words.count) * averageTokensPerWord

        // Round to nearest integer and return
        return Int(round(tokenCountEstimate))
    }
}

