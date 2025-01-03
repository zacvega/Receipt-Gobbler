import SwiftUI

struct NewReceiptView: View {
    @State private var showCamera = false
    @State private var showCameraAlert = false
    @State private var capturedImage: UIImage?
    @State private var recognizedText = "Tap button to start scanning"
    
    @State var newReceiptInfo: ReceiptInfo = syntheticData.testReceipt1
    
    @State private var path: [String] = []
    
    @State var isLoading: Bool = true
    @State private var _wasOnReceiptForm2: Bool = false

    var body: some View {
        NavigationStack(path: $path) {
            VStack(spacing: 30.0) {
                NavigationLink(value: "receipt_form_1") {
                    Text("Type")
                        .font(.title)
                        .padding()
                        .frame(width: 200.0)
                        .background(.cyan)
                        .foregroundStyle(.white)
                        .cornerRadius(30)
                }
                
                NavigationLink(value: "receipt_scan") {
                    Text("Scan")
                        .font(.title)
                        .padding()
                        .frame(width: 200.0)
                        .background(.blue)
                        .foregroundStyle(.white)
                        .cornerRadius(30)
                }
                NavigationLink(value: "receipt_import") {
                    Text("Import")
                        .font(.title)
                        .padding()
                        .frame(width: 200.0)
                        .background(.orange)
                        .foregroundStyle(.white)
                        .cornerRadius(30)
                }
            }
            .padding()
            .navigationTitle("New Receipt")
            .navigationDestination(for: String.self) { value in
                if value == "receipt_form_1" {
                    ReceiptFormView(newReceiptInfo: $newReceiptInfo, parentPath: $path)
                }
                else if value == "receipt_form_2" {
                    if !isLoading {
                        ReceiptFormView(newReceiptInfo: $newReceiptInfo, parentPath: $path)
                    }
                    else {
                        LoadingView()
                    }
                }
                else if value == "receipt_scan" {
                    ScanDocumentView(recognizedText: $recognizedText, returnedNewReceiptInfo: $newReceiptInfo, parentPath: $path, isLoading: $isLoading)
                }
                else if value == "receipt_import" {
                    VStack {}
//                    ReceiptImportView()
                }
            }
            .onChange(of: path) { newPath in
                // called whenever the current page updates
                let newPage = newPath.last
                if newPage == "receipt_form_2" {
                    _wasOnReceiptForm2 = true
                }
                else if _wasOnReceiptForm2 {
                    // just returned from receipt form, must cleanup
                    _wasOnReceiptForm2 = false
                    isLoading = true
                }
            }
        }
    }
}

struct NewReceiptView_Previews: PreviewProvider {
    static var previews: some View {
        NewReceiptView()
    }
}
