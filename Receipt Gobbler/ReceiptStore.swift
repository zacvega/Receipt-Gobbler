import Foundation
struct Receipt: Identifiable {
    let id = UUID() // Unique identifier for each receipt
    let storeName: String
    let items: [String]
    let price: Double
    let date: Date // Changed from time to date
}
class ReceiptStore: ObservableObject {
    @Published var receipts: [Receipt] = []

    static let shared = ReceiptStore()

    // Method to add a new receipt
    func addReceipt(storeName: String, items: [String], price: Double, date: Date) {
        let newReceipt = Receipt(storeName: storeName, items: items, price: price, date: date)
        receipts.append(newReceipt)
    }
    
    // Computed property to get the total spend for the current month
    var totalSpendThisMonth: Double {
        let calendar = Calendar.current
        let currentMonth = calendar.component(.month, from: Date())
        let currentYear = calendar.component(.year, from: Date())

        return receipts.filter { receipt in
            let receiptMonth = calendar.component(.month, from: receipt.date)
            let receiptYear = calendar.component(.year, from: receipt.date)
            return receiptMonth == currentMonth && receiptYear == currentYear
        }.reduce(0) { total, receipt in
            total + receipt.price
        }
    }
}
