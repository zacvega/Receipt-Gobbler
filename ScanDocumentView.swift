//
//  ScanDocumentView.swift
//  Text Recognition Sample
//
//  Created by Stefan Blos on 25.05.20.
//  Copyright © 2020 Stefan Blos. All rights reserved.
//

import SwiftUI
import VisionKit
import Vision

func centerOfRect(_ x1: Double, _ y1: Double, _ x2: Double, _ y2: Double) -> (Double, Double) {
    return ((x1+x2)/2.0, (y1+y2)/2.0)
}

// cleans up OCR output
func cleanupOcr(_ recogs: [Recognition]) -> String {
    // lines looks like [ [r1,r2], [r3], [r4, r5, r6], ... ]
    var lines: [[Recognition]] = []
    // for each recog, find other recogs on the same line
    for l in recogs {
        if l.matched {
            continue
        }
        l.matched = true
        
        let l_max = l.y1
        let l_min = l.y2
        var line = [l]
        
        for r in recogs {
            if r.matched {
                continue
            }
            
            // check if the right recog's center is within a rectangle extending from the left recog's bounding box all the way to the right
            if (l_min <= r.cy && r.cy <= l_max) {
                r.matched = true
                line.append(r)
            }
        }
        lines.append(line)
    }
    
    // convert to text
    // TODO: normalize the output based on the longest line's length
    var out = ""
    for line in lines {
        var lineText = ""
    
        // if the line only has one entry, just output that on the appropriate side
        if line.count == 1 {
            let r = line[0]
            switch r.side {
            case "L":
                lineText += r.text
            case "R":
                lineText += "        \(r.text)"
            case "C":
                lineText += "    \(r.text)    "
            default:
                break
            }
        }
        else {
            // else, sort everything on this line by its x value and output it in order
            let sortedLine = line.sorted(by: { (s1: Recognition, s2: Recognition) -> Bool in
                s1.cx < s2.cx
            })
            for r in sortedLine[0 ..< sortedLine.count-1] {
                lineText += "\(r.text)    "
            }
            lineText += "\(sortedLine[sortedLine.count-1].text)"
        }
        
        out += lineText + "\n"
    }
    return out
}

// uses AI to extract structured data from the cleaned up OCR output
func extractReceiptData(_ cleanOcrOutput: String) async -> ReceiptInfo {
//    let prompt = "mini_extract"
//    let schema = "structured_no_alias"
//    let api = "openAI"
//    let result = await ExtractionAPI.extractData(inputString: cleanOcrOutput, promptString: prompt, schemaString: schema, apiString: api)
    
//    if let result {
//        print(result)
//    }
    
    
    
    // TODO: return real data
    return syntheticData.testReceipt2
}

class Recognition {
    let text: String
    let x1: Double
    let y1: Double
    let x2: Double
    let y2: Double
    
    var matched: Bool
    let cx: Double
    let cy: Double
    let side: String // "L", "R", or "C"
    
    init(text: String, x1: Double, y1: Double, x2: Double, y2: Double) {
        self.text = text
        self.x1 = x1
        self.y1 = y1
        self.x2 = x2
        self.y2 = y2
        self.matched = false
        (self.cx, self.cy) = centerOfRect(x1, y1, x2, y2)
        
        if 0.5-0.05 <= self.cx && self.cx <= 0.5+0.05 {
            // is in center
            self.side = "C"
        }
        else {
            let left_dist = self.cx
            let right_dist = 1.0 - self.cx
            if left_dist < right_dist {
                self.side = "L"
            }
            else {
                self.side = "R"
            }
        }
    }
}

struct ScanDocumentView: UIViewControllerRepresentable {
    
    @Environment(\.presentationMode) var presentationMode
    @Binding var recognizedText: String
    
    //Modify this to pass back recognized info
    //Should navigate to a ReceiptFormView instance when done scanning, for user to edit
    @Binding var returnedNewReceiptInfo: ReceiptInfo
    
    @Binding var parentPath: [String]
    
    func makeCoordinator() -> Coordinator {
        Coordinator(recognizedText: $recognizedText, parent: self)
    }
    
    func makeUIViewController(context: Context) -> VNDocumentCameraViewController {
        let documentViewController = VNDocumentCameraViewController()
        documentViewController.delegate = context.coordinator
        return documentViewController
    }
    
    func updateUIViewController(_ uiViewController: VNDocumentCameraViewController, context: Context) {
        // nothing to do here
    }
    
    class Coordinator: NSObject, VNDocumentCameraViewControllerDelegate {
        var recognizedText: Binding<String>
        var parent: ScanDocumentView
        
        init(recognizedText: Binding<String>, parent: ScanDocumentView) {
            self.recognizedText = recognizedText
            self.parent = parent
        }
        
        func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFinishWith scan: VNDocumentCameraScan) {
            let extractedImages = extractImages(from: scan)
            let ocrOutput = recognizeText(from: extractedImages)
            let cleanedOcrOutput = cleanupOcr(ocrOutput)
            print(cleanedOcrOutput)
            //            recognizedText.wrappedValue = processedText
            
            Task {
                let extractedData = await extractReceiptData(cleanedOcrOutput)
                parent.returnedNewReceiptInfo = extractedData
                parent.parentPath.append("receipt_form")
                // parent.presentationMode.wrappedValue.dismiss()
            }

            
        }
        
        fileprivate func extractImages(from scan: VNDocumentCameraScan) -> [CGImage] {
            var extractedImages = [CGImage]()
            for index in 0..<scan.pageCount {
                let extractedImage = scan.imageOfPage(at: index)
                guard let cgImage = extractedImage.cgImage else { continue }
                
                extractedImages.append(cgImage)
            }
            return extractedImages
        }
        
        fileprivate func recognizeText(from images: [CGImage]) -> [Recognition] {
//            var entireRecognizedText = ""
            var recognitions: [Recognition] = []
            let recognizeTextRequest = VNRecognizeTextRequest { (request, error) in
                guard error == nil else { return }
                
                guard let observations = request.results as? [VNRecognizedTextObservation] else { return }
                
                //let maximumRecognitionCandidates = 1
                for observation in observations {
                    guard let candidate = observation.topCandidates(1).first else { continue }
                    
                    // NOTE: boundingBox precision level is per-word rather than per-character at `.accurate` precision
    
                    // get the coordinates of the bounding box for this entire recognition
                    let boundingBox = try? candidate.boundingBox(for: candidate.string.startIndex..<candidate.string.endIndex)
                    if let boundingBox {
                        // dump all info about it
//                        print("\(boundingBox.topLeft.x)|\(boundingBox.topLeft.y)|\(boundingBox.bottomRight.x)|\(boundingBox.bottomRight.y)|\(candidate.string)")
                        
                        recognitions.append(Recognition(
                            text: candidate.string,
                            x1: boundingBox.topLeft.x,
                            y1: boundingBox.topLeft.y,
                            x2: boundingBox.bottomRight.x,
                            y2: boundingBox.bottomRight.y)
                        )
                    }
                    
//                    entireRecognizedText += "\(candidate.string)\n"
                    
                }
            }
            recognizeTextRequest.recognitionLevel = .accurate
            
            for image in images {
                let requestHandler = VNImageRequestHandler(cgImage: image, options: [:])
                
                try? requestHandler.perform([recognizeTextRequest])
            }
            
            return recognitions
        }
    }
}
