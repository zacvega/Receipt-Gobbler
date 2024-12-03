//
//  ReceiptImportView.swift
//  Receipt Gobbler
//
//  Created by Matt on 12/3/24.
//

//import PhotosUI
//import SwiftUI
//
//struct ReceiptImportView: View {
//    @State private var avatarItem: PhotosPickerItem?
//    @State private var avatarImage: Image?
//
//    var body: some View {
//        VStack {
//            PhotosPicker("Select avatar", selection: $avatarItem, matching: .images)
//
//            avatarImage?
//                .resizable()
//                .scaledToFit()
//                .frame(width: 300, height: 300)
//        }
//        .onChange(of: avatarItem) { _ in
//            Task {
//                if let loaded = try? await avatarItem?.loadTransferable(type: Image.self) {
//                    avatarImage = loaded
//                } else {
//                    print("Failed")
//                }
//            }
//        }
//    }
//}
//
//struct ReceiptImportView_Previews: PreviewProvider {
//    static var previews: some View {
//        ReceiptImportView()
//    }
//}
