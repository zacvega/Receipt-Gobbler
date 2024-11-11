import SwiftUI

struct NewReceiptView: View {
    @State private var showCamera = false
    @State private var showCameraAlert = false
    @State private var capturedImage: UIImage?
    @State private var recognizedText = "Tap button to start scanning"
    //for navigation
    @State private var isButtonPressed: Bool = false

    var body: some View {
        VStack {
            // Take a Picture Button
            
        
            NavigationLink{ ReceiptFormView()
            } label: {
                Text("Type")
                    .font(.title)
                    .padding()
                    .frame(width: 200.0)
                    .background(.cyan)
                    .foregroundStyle(.white)
                    .cornerRadius(30)
            }
            NavigationLink{ ScanDocumentView(recognizedText: $recognizedText)
            } label: {
                Text("Scan")
                    .font(.title)
                    .padding()
                    .frame(width: 200.0)
                    .background(.cyan)
                    .foregroundStyle(.white)
                    .cornerRadius(30)
            }
            Text("\(recognizedText)")
                            .padding()
                            .frame(width: 300)
                            .background(Color.blue.opacity(0.1))
                            .cornerRadius(8)
                            .multilineTextAlignment(.center)
            

//            // Type In Button
//            NavigationLink(destination: ReceiptFormView()) {
//                Text("Type In")
//                    .font(.title)
//                    .padding()
//                    .background(Color.purple)
//                    .foregroundColor(.white)
//                    .cornerRadius(30)
//            }
//            .padding()

            // Previous Receipts Button
            

            //Spacer()
        }
        .padding()
        .navigationTitle("New Receipt")
    }
}

struct NewReceiptView_Previews: PreviewProvider {
    static var previews: some View {
        NewReceiptView()
    }
}
