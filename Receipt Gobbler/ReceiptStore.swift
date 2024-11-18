import Foundation
struct Receipt: Identifiable {
    let id = UUID() // Unique identifier for each receipt
    let storeName: String
    let items: [String]
    let price: Double
    let date: Date // Changed from time to date
}

//------ added by David -----
struct ReceiptInfo: Identifiable {
    let id = UUID()
    var summary: ReceiptSummary
    var details: ReceiptDetail
}

extension ReceiptInfo {
    init(){
        summary = ReceiptSummary()
        details = ReceiptDetail(merchant: Merchant(), items: [Item()])
    }
}

struct ReceiptSummary: Identifiable {
    let id = UUID()
//    let merchant_id: Int
    var merchant_name: String = ""
//    let merchant: Merchant
    var total_cost_including_tax: Double = 0.0
    var tax: Double = 1.37
    var time_purchased: Date = Date()
}

struct ReceiptDetail {
    var merchant: Merchant
    var items: [Item]
}

struct Merchant{
    var name: String = ""
    var address: String = ""
    var phone: String = ""
}

struct Item: Identifiable {
    let id = UUID()
    var name: String = ""
    var unitPrice: Float = 0.0
    var quantity: Float = 0.0
}


extension Date {
    init?(dateString: String) {
        let dateStringFormatter = DateFormatter()
        dateStringFormatter.dateFormat = "yyyy-MM-dd"
        if let d = dateStringFormatter.date(from: dateString) {
            self.init(timeInterval: 0, since: d)
        } else {
            return nil
        }
    }
}
//---^^^



class ReceiptStore: ObservableObject {
//    @Published var receipts: [Receipt] = []
    @Published var fakeData = syntheticData()

    static let shared = ReceiptStore()
    
    @Published var receiptsDict: [UUID: ReceiptInfo] = Dictionary(uniqueKeysWithValues: syntheticData.fullInfo.map{($0.id, $0)})
    
    func createReceiptNew(newReceiptInfo: ReceiptInfo){
        DLOG("createReceiptNew()")
        receiptsDict[newReceiptInfo.id] = newReceiptInfo
//        objectWillChange.send()
    }
    
    func readReceipt(id: UUID) -> ReceiptInfo{
        //needs to handle error when id doesnt exist
        return receiptsDict[id]!
    }

    func updateReceipt(newReceiptInfo: ReceiptInfo){
        receiptsDict[newReceiptInfo.id] = newReceiptInfo
        
    }
    
    func deleteReceipt(id: UUID){
        //maybe explore remove()
        receiptsDict[id] = nil
    }
    
    
    
    // Method to add a new receipt
//    func addReceipt(storeName: String, items: [String], price: Double, date: Date) {
//        let newReceipt = Receipt(storeName: storeName, items: items, price: price, date: date)
//        receipts.append(newReceipt)
//    }
    
    
    // Computed property to get the total spend for the current month
    var totalSpendThisMonth: Double {
        DLOG("totalSpendThisMonth()")
        let calendar = Calendar.current
        let currentMonth = calendar.component(.month, from: Date())
        let currentYear = calendar.component(.year, from: Date())
  
        var totalSpend = 0.0
        for rEntry in receiptsDict {
            let receiptInfo = rEntry.value
            let receiptDate = receiptInfo.summary.time_purchased
            let receiptMonth = calendar.component(.month, from: receiptDate)
            let receiptYear = calendar.component(.year, from: receiptDate)
            if receiptMonth == currentMonth && receiptYear == currentYear {
                totalSpend += receiptInfo.summary.total_cost_including_tax
            }
        }
        
        return totalSpend
    }
}


struct syntheticData{
    static var testReceipt1 : ReceiptInfo = fullInfo[5]
    static var testReceipt2 : ReceiptInfo = fullInfo[0]
    
    static var fullInfo : [ReceiptInfo] = [
        // First ReceiptInfo (Plaza 900)
        ReceiptInfo(
            summary: ReceiptSummary(merchant_name: "Plaza 900", total_cost_including_tax: 12.005, time_purchased: Date(dateString: "2024/01/02")!),
            details: ReceiptDetail(
                merchant: Merchant(name: "Plaza 900", address: "900 Virginia Ave, Columbia, MO 65211", phone: "573-882-4723"),
                items: [
                    Item(name: "Lunch", unitPrice: 12.55, quantity: 1),
                    Item(name: "Fruit", unitPrice: 2.50, quantity: 2)
                ]
            )
        ),
        
        // Second ReceiptInfo (The Mark)
        ReceiptInfo(
            summary: ReceiptSummary(merchant_name: "The Mark", total_cost_including_tax: 47.97, time_purchased: Date(dateString: "2024/02/01")!),
            details: ReceiptDetail(
                merchant: Merchant(name: "The Mark", address: "1034 Broadway St, Columbia, MO 65201", phone: "573-555-1234"),
                items: [
                    Item(name: "Steak", unitPrice: 19.99, quantity: 1),
                    Item(name: "Salad", unitPrice: 7.99, quantity: 2),
                    Item(name: "Soda", unitPrice: 1.75, quantity: 3)
                ]
            )
        ),
        
        // Third ReceiptInfo (Domino's)
        ReceiptInfo(
            summary: ReceiptSummary(merchant_name: "Domino's", total_cost_including_tax: 47.96, time_purchased: Date(dateString: "2024/03/31")!),
            details: ReceiptDetail(
                merchant: Merchant(name: "Domino's", address: "740 W Business Loop 70, Columbia, MO 65203", phone: "573-555-5678"),
                items: [
                    Item(name: "Pizza", unitPrice: 15.99, quantity: 2),
                    Item(name: "Garlic Bread", unitPrice: 5.49, quantity: 1),
                    Item(name: "Soda", unitPrice: 1.25, quantity: 3)
                ]
            )
        ),
        
        // Fourth ReceiptInfo (Starbucks)
        ReceiptInfo(
            summary: ReceiptSummary(merchant_name: "Starbucks", total_cost_including_tax: 12.75, time_purchased: Date(dateString: "2024/04/10")!),
            details: ReceiptDetail(
                merchant: Merchant(name: "Starbucks", address: "501 E Broadway, Columbia, MO 65201", phone: "573-555-8901"),
                items: [
                    Item(name: "Coffee", unitPrice: 4.50, quantity: 2),
                    Item(name: "Pastry", unitPrice: 3.75, quantity: 1)
                ]
            )
        ),
        
        // Fifth ReceiptInfo (Target)
        ReceiptInfo(
            summary: ReceiptSummary(merchant_name: "Target", total_cost_including_tax: 22.94, time_purchased: Date(dateString: "2024/04/15")!),
            details: ReceiptDetail(
                merchant: Merchant(name: "Target", address: "2300 Bernadette Dr, Columbia, MO 65203", phone: "573-555-2468"),
                items: [
                    Item(name: "Shampoo", unitPrice: 5.99, quantity: 2),
                    Item(name: "Toothpaste", unitPrice: 2.99, quantity: 1),
                    Item(name: "Toilet Paper", unitPrice: 6.99, quantity: 1)
                ]
            )
        ),
        
        // Sixth ReceiptInfo (Walmart)
        ReceiptInfo(
            summary: ReceiptSummary(merchant_name: "Walmart", total_cost_including_tax: 27.64, time_purchased: Date(dateString: "2024/04/20")!),
            details: ReceiptDetail(
                merchant: Merchant(name: "Walmart", address: "111 S Providence Rd, Columbia, MO 65203", phone: "573-555-1357"),
                items: [
                    Item(name: "Bananas", unitPrice: 0.58, quantity: 6),
                    Item(name: "Chicken Breast", unitPrice: 8.99, quantity: 1),
                    Item(name: "Broccoli", unitPrice: 2.49, quantity: 1),
                    Item(name: "Shampoo", unitPrice: 5.99, quantity: 2),
                    Item(name: "Toothpaste", unitPrice: 2.99, quantity: 1),
                    Item(name: "Toilet Paper", unitPrice: 6.99, quantity: 1),
                    Item(name: "Pizza", unitPrice: 15.99, quantity: 2),
                    Item(name: "Garlic Bread", unitPrice: 5.49, quantity: 1),
                    Item(name: "Soda", unitPrice: 1.25, quantity: 3),
                    Item(name: "Bananas", unitPrice: 0.58, quantity: 6),
                    Item(name: "Chicken Breast", unitPrice: 8.99, quantity: 1),
                    Item(name: "Broccoli", unitPrice: 2.49, quantity: 1),
                    Item(name: "Shampoo", unitPrice: 5.99, quantity: 2),
                    Item(name: "Toothpaste", unitPrice: 2.99, quantity: 1),
                    Item(name: "Toilet Paper", unitPrice: 6.99, quantity: 1),
                    Item(name: "Pizza", unitPrice: 15.99, quantity: 2),
                    Item(name: "Garlic Bread", unitPrice: 5.49, quantity: 1),
                    Item(name: "Soda", unitPrice: 1.25, quantity: 3),
                    Item(name: "Bananas", unitPrice: 0.58, quantity: 6),
                    Item(name: "Chicken Breast", unitPrice: 8.99, quantity: 1),
                    Item(name: "Broccoli", unitPrice: 2.49, quantity: 1),
                    Item(name: "Shampoo", unitPrice: 5.99, quantity: 2),
                    Item(name: "Toothpaste", unitPrice: 2.99, quantity: 1),
                    Item(name: "Toilet Paper", unitPrice: 6.99, quantity: 1),
                    Item(name: "Pizza", unitPrice: 15.99, quantity: 2),
                    Item(name: "Garlic Bread", unitPrice: 5.49, quantity: 1),
                    Item(name: "Soda", unitPrice: 1.25, quantity: 3)
                ]
            )
        )
    ]

    var summaries : [ReceiptSummary] = [
        // Existing summary for Plaza 900
        ReceiptSummary(merchant_name: "Plaza 900", total_cost_including_tax: 12.005, time_purchased: Date(dateString: "2024/01/02")!),
        
        // New summary for The Mark
        ReceiptSummary(merchant_name: "The Mark", total_cost_including_tax: 47.97, time_purchased: Date(dateString: "2024/02/01")!),
        
        // New summary for Domino's
        ReceiptSummary(merchant_name: "Domino's", total_cost_including_tax: 47.96, time_purchased: Date(dateString: "2024/03/31")!),
        
        // New summary for Starbucks
        ReceiptSummary(merchant_name: "Starbucks", total_cost_including_tax: 12.75, time_purchased: Date(dateString: "2024/04/10")!),
        
        // New summary for Target
        ReceiptSummary(merchant_name: "Target", total_cost_including_tax: 22.94, time_purchased: Date(dateString: "2024/04/15")!),
        
        // New summary for Walmart
        ReceiptSummary(merchant_name: "Walmart", total_cost_including_tax: 27.64, time_purchased: Date(dateString: "2024/04/20")!)
    ]
    
    var details: [ReceiptDetail] = [
        // Existing receipt detail for Plaza 900
        ReceiptDetail(merchant: Merchant(name: "Plaza 900", address: "900 Virginia Ave, Columbia, MO 65211", phone: "573-882-4723"), items: [
            Item(name: "Lunch", unitPrice: 12.55, quantity: 1),
            Item(name: "Fruit", unitPrice: 2.50, quantity: 2)
        ]),
        
        // New receipt detail for The Mark
        ReceiptDetail(merchant: Merchant(name: "The Mark", address: "1034 Broadway St, Columbia, MO 65201", phone: "573-555-1234"), items: [
            Item(name: "Steak", unitPrice: 19.99, quantity: 1),
            Item(name: "Salad", unitPrice: 7.99, quantity: 2),
            Item(name: "Soda", unitPrice: 1.75, quantity: 3)
        ]),
        
        // New receipt detail for Domino's
        ReceiptDetail(merchant: Merchant(name: "Domino's", address: "740 W Business Loop 70, Columbia, MO 65203", phone: "573-555-5678"), items: [
            Item(name: "Pizza", unitPrice: 15.99, quantity: 2),
            Item(name: "Garlic Bread", unitPrice: 5.49, quantity: 1),
            Item(name: "Soda", unitPrice: 1.25, quantity: 3)
        ]),
        
        // New receipt detail for Starbucks
        ReceiptDetail(merchant: Merchant(name: "Starbucks", address: "501 E Broadway, Columbia, MO 65201", phone: "573-555-8901"), items: [
            Item(name: "Coffee", unitPrice: 4.50, quantity: 2),
            Item(name: "Pastry", unitPrice: 3.75, quantity: 1)
        ]),
        
        // New receipt detail for Target
        ReceiptDetail(merchant: Merchant(name: "Target", address: "2300 Bernadette Dr, Columbia, MO 65203", phone: "573-555-2468"), items: [
            Item(name: "Shampoo", unitPrice: 5.99, quantity: 2),
            Item(name: "Toothpaste", unitPrice: 2.99, quantity: 1),
            Item(name: "Toilet Paper", unitPrice: 6.99, quantity: 1)
        ]),
        
        // New receipt detail for Walmart
        ReceiptDetail(merchant: Merchant(name: "Walmart", address: "111 S Providence Rd, Columbia, MO 65203", phone: "573-555-1357"), items: [
            Item(name: "Bananas", unitPrice: 0.58, quantity: 6),
            Item(name: "Chicken Breast", unitPrice: 8.99, quantity: 1),
            Item(name: "Broccoli", unitPrice: 2.49, quantity: 1)
        ])
    ]
    
}



