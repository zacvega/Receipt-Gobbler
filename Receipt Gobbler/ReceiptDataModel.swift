import Foundation

//replaces ReceiptStore

//struct ReceiptSummary: Identifiable {

struct Receipt {
    let summary: ReceiptSummary
    let details: ReceiptDetail
}

struct ReceiptSummary {
//    let id = UUID()
//    let merchant_id: Int
    let merchant_name: String
//    let merchant: Merchant
    let total_cost: Double
    let time_purchased: Date
}

struct ReceiptDetail {
    let merchant: Merchant
    let items: [Item]
}

struct Item {
    let itemName: String
    let amount: Double
    let unitPrice: Double
}

struct Merchant {
    let name: String
    let address: String
    let phoneNumber: String
}



class ReceiptDataModel: ObservableObject {
    static let shared = ReceiptDataModel()
    
    @Published private(set) var receipts: [ReceiptSummary] = []
    
    var db: DatabaseHelper = DatabaseHelper()

    private init() {}

    func addReceipt(receipt:ReceiptSummary) {
        receipts.append(receipt)
//        db.insertReceipt(merchantName: merchantName, totalPrice: totalPrice, itemsNameAndUnitprice: items)
//        db.insertItems(itemsNameAndUnitprice: items)
    }
}
