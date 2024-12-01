//
//  LoadingView.swift
//  Receipt Gobbler
//
//  Created by Matt on 11/30/24.
//

import SwiftUI

struct LoadingView: View {
//    @Environment(\.dismiss) private var dismiss
    
//    @Binding var isLoading: Bool
    
    var body: some View {
        VStack {
//            if isLoading {
                ProgressView().progressViewStyle(CircularProgressViewStyle())
//            }
        }
    }
}

struct LoadingView_Preview: PreviewProvider{
    @StateObject static var dataModel: ReceiptStore = ReceiptStore()
    
    @State static var isLoading: Bool = true
    
    static var previews: some View{
//        LoadingView(isLoading: $isLoading)
        LoadingView()
//            .environmentObject(dataModel)
    }
}
