import SwiftUI

struct NewReceiptView: View {
    @State private var showCamera = false
    @State private var showCameraAlert = false
    @State private var capturedImage: UIImage?

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
                Text("Take a Picture")
                    .font(.title)
                    .padding()
                    .background(Color.orange)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding(.top, 20)
            .sheet(isPresented: $showCamera) {
                CameraView(image: $capturedImage)
            }
            .alert(isPresented: $showCameraAlert) {
                Alert(title: Text("Camera Not Available"), message: Text("Your device does not support camera functionality."), dismissButton: .default(Text("OK")))
            }

            // Type In Button
            NavigationLink(destination: ReceiptFormView()) {
                Text("Type In")
                    .font(.title)
                    .padding()
                    .background(Color.purple)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding(.top, 20)

            // Previous Receipts Button
            

            Spacer()
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
