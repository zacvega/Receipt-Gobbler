import SwiftUI

struct NewReceiptView: View {
    @State private var showCamera = false
    @State private var showCameraAlert = false
    @State private var capturedImage: UIImage?
    
    //for navigation
    @State private var isButtonPressed: Bool = false

    var body: some View {
        VStack {
            // Take a Picture Button
            Button(action: {
                if UIImagePickerController.isSourceTypeAvailable(.camera) {
                    showCamera = true
                } else {
                    showCameraAlert = true
                }
            }) {
                Text("Scan")
                    .font(.title)
                    .padding()
                    .frame(width: 200.0)
                    .background(.blue)
                    .foregroundColor(.white)
                    .cornerRadius(30)
            }
            .padding()
            .sheet(isPresented: $showCamera) {
                CameraView(image: $capturedImage)
            }
            .alert(isPresented: $showCameraAlert) {
                Alert(title: Text("Camera Not Available"), message: Text("Your device does not support camera functionality."), dismissButton: .default(Text("OK")))
            }
            
            
            
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
