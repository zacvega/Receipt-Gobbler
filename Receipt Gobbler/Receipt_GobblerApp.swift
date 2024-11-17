//
//  Receipt_GobblerApp.swift
//  Receipt Gobbler
//
//  Created by jinshi bai on 9/3/24.
//

import SwiftUI

// calls into the API in the background and eventually prints the result out to the Xcode output
// useful for debugging
func apiDemo() {
    let CLEAN_OCR_OUT_URL = Bundle.main.url(forResource: "clean_ocr_out_example_1", withExtension: "txt")!
    
    let CLEAN_OCR_OUT: String?
    do {
        CLEAN_OCR_OUT = try String(contentsOf: CLEAN_OCR_OUT_URL, encoding: .utf8)
    } catch { CLEAN_OCR_OUT = nil }

    Task {
        let prompt = "mini_extract"
        let schema = "extraction_structured_no_alias"
        let api = "openAI"
        let result = await ExtractionAPI.extractData(inputString: CLEAN_OCR_OUT!, promptString: prompt, schemaString: schema, apiString: api)
        if let result {
            print(result)
        }
        
    }
}

@main
struct Receipt_GobblerApp: App {
    //var mainPageView = ContentView()
    @StateObject var dataModel: ReceiptStore = ReceiptStore()
    
    init() {
        
        apiDemo()

    }
    
    var body: some Scene {
        WindowGroup {
            //mainPageView
            ContentView()
                .environmentObject(dataModel)
            
        }
    }
}
