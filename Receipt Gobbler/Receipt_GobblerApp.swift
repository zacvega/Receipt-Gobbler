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
// if true, synthetic in-memory data is used
// if false, receipts are peristed to the disk and synthetic data isn't used
let USE_FAKE_RECEIPT_DATA = true
// if true, the app's data will be purged upon the next app launch
let CLEAR_APP_DATA = false


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
        for param in params {
            print(param)
        }
    }
}

enum FatalError: Error {
    case unexpected
}

func loadFakeReceiptStore() -> ReceiptStore {
    DLOG("using fake data")
    let rs = ReceiptStore()
    rs.receiptsDict = Dictionary(uniqueKeysWithValues: syntheticData.fullInfo.map{($0.id, $0)})
    rs.onModelUpdated()
    return rs
}

func loadReceiptStore() throws -> ReceiptStore {
    if CLEAR_APP_DATA {
        clearAppData()
    }

    if USE_FAKE_RECEIPT_DATA {
        return loadFakeReceiptStore()
    }
    
    let rs = ReceiptStore()
    
    let receiptInfoList = try? loadJsonToMemory()
    if receiptInfoList == nil {
        DLOG("tried to load real data but got none")
        // this always should succeed, returning blank data here might overwrite real data; must throw
        throw FatalError.unexpected
    }
    
    let realData = Dictionary(uniqueKeysWithValues: receiptInfoList!.map{($0.id, $0)})
    rs.receiptsDict = realData
    rs.onModelUpdated(commitChanges: false) // updating the json would be pointless since it hasn't changed yet
    
    return rs
}

@main
struct Receipt_GobblerApp: App {
    @StateObject var dataModel: ReceiptStore = {
        do {
            return try loadReceiptStore()
        } catch {
            fatalError("loading receipt store failed")
        }
    }()
    
    init() {
        
//        Task { await apiDemo() } // launch real api demo in background
        
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(dataModel)
            
        }
    }
}
