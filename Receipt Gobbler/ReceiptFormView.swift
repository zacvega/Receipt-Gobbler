import SwiftUI

struct ReceiptFormView: View {
    @State private var storeName: String = ""
    @State private var items: String = ""
    @State private var price: String = ""
    @State private var receiptDate: Date = Date() // Use for the date input
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        Form {
            Section(header: Text("Store Information")) {
                TextField("Store Name", text: $storeName)
            }

            Section(header: Text("Items")) {
                TextField("Items (comma-separated)", text: $items)
            }

            Section(header: Text("Price")) {
                TextField("Total Price", text: $price)
                    .keyboardType(.decimalPad)
            }

            // Date Picker for receipt date input
            Section(header: Text("Date of Purchase")) {
                DatePicker("Select Date", selection: $receiptDate, displayedComponents: .date)
                    .datePickerStyle(GraphicalDatePickerStyle()) // Use a graphical style for better UX
            }

            Button(action: saveReceipt) {
                Text("Save Receipt")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding(.top, 20)
        }
        .navigationTitle("New Receipt")
        .navigationBarTitleDisplayMode(.inline)
    }

    private func saveReceipt() {
        guard let price = Double(price) else {
            print("Invalid price")
            return
        }

        let itemsArray = items.split(separator: ",").map { $0.trimmingCharacters(in: .whitespaces) }

        // Save receipt with the selected date
        ReceiptStore.shared.addReceipt(storeName: storeName, items: itemsArray, price: price, date: receiptDate)
        presentationMode.wrappedValue.dismiss() // Go back to the previous screen
    }
}

struct ReceiptFormView_Previews: PreviewProvider {
    static var previews: some View {
        ReceiptFormView()
    }
}
