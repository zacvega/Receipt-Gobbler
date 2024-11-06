import Vision
import UIKit

func extractText(from image: UIImage) -> String? {
    guard let cgImage = image.cgImage else { return nil }
    var recognizedText: String?

    let request = VNRecognizeTextRequest { (request, error) in
        if let error = error {
            print("Error recognizing text: \(error)")
            return
        }

        recognizedText = request.results?.compactMap { result -> String? in
            guard let observation = result as? VNRecognizedTextObservation else { return nil }
            return observation.topCandidates(1).first?.string
        }.joined(separator: "\n")
    }

    request.recognitionLevel = .accurate
    request.usesLanguageCorrection = true

    let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])
    try? handler.perform([request])

    return recognizedText
}

func imageFromData(_ data: Data) -> UIImage? {
    return UIImage(data: data)
}
