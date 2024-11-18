//
//  Receipt_GobblerApp.swift
//  Receipt Gobbler
//
//  Created by jinshi bai on 9/3/24.
//

import SwiftUI


/*
 [DEBUG SWITCHES]
*/

// use a cached response generated using the example Chiptole receipt instead of the real API
// the Chipotle example is stored in AI_API/ExampleOutputs/1/
let USE_MOCK_API_RESPONSE = true
// extra logging to Xcode output panel
let DEBUG_LOGGING = true


// calls into the API in the background and eventually prints the result out to the Xcode output
// useful for debugging
func apiDemo() async {
    let CLEAN_OCR_OUT_URL = Bundle.main.url(forResource: "chipotle_cleaned_ocr_output", withExtension: "txt")!
    let CLEAN_OCR_OUT: String?
    do {
        CLEAN_OCR_OUT = try String(contentsOf: CLEAN_OCR_OUT_URL, encoding: .utf8)
    } catch { CLEAN_OCR_OUT = nil }
    
    let prompt = "mini_extract"
    let schema = "extraction_structured_no_alias"
    let api = "openAI"
    let result = await ExtractionAPI.extractData(inputString: CLEAN_OCR_OUT!, promptString: prompt, schemaString: schema, apiString: api)
    if let result {
        print(result)
    }
}

func DLOG(_ params: Any...) {
    if DEBUG_LOGGING {
        print(params)
    }
}

@main
struct Receipt_GobblerApp: App {
    //var mainPageView = ContentView()
    @StateObject var dataModel: ReceiptStore = ReceiptStore()
    
    init() {
        
        
//        Task { await apiDemo() } // launch real api demo in background
        
        
    }
    
    var body: some Scene {
        WindowGroup {
            //mainPageView
            ContentView()
                .environmentObject(dataModel)
            
        }
    }
}
