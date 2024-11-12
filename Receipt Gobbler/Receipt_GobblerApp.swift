//
//  Receipt_GobblerApp.swift
//  Receipt Gobbler
//
//  Created by jinshi bai on 9/3/24.
//

import SwiftUI

@main
struct Receipt_GobblerApp: App {
    //var mainPageView = ContentView()
    @StateObject var dataModel: ReceiptStore = ReceiptStore()
    
    var body: some Scene {
        WindowGroup {
            //mainPageView
            ContentView()
                .environmentObject(dataModel)
            
        }
    }
}
