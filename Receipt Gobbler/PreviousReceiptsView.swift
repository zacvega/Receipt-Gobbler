import SwiftUI

struct PreviousReceiptsView: View {
    @ObservedObject var receiptStore = ReceiptStore.shared

    var body: some View {
        List {
            ForEach(receiptStore.receipts) { receipt in
                VStack(alignment: .leading) {
                    Text(receipt.storeName)
                        .font(.headline)
                    Text("Items: \(receipt.items.joined(separator: ", "))")
                    Text("Price: $\(receipt.price, specifier: "%.2f")")
                    Text("Date: \(receipt.date, formatter: dateFormatter)") // Display the date
                }
            }
        }
        .navigationTitle("Previous Receipts")
    }

    // Formatter to display the date in a readable format
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium  // Adjust the date format as needed (medium, long, short, etc.)
        formatter.timeStyle = .none  // No time component
        return formatter
    }
}
