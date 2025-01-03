import Foundation

func clearAppData() {
    let appDataDirFP: URL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    let jsonFP: URL = appDataDirFP.appending(path: "data.json")
    
    do { try FileManager.default.removeItem(at: jsonFP) } catch { DLOG("[!] clear data failed"); return }
    DLOG("cleared app data")
}

func dumpMemoryToJson(_ receiptInfoList: [ReceiptInfo]) throws {
    let encoder = JSONEncoder()
    let appDataDirFP: URL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    let jsonFP: URL = appDataDirFP.appending(path: "data.json")
    
    let jsonData = try encoder.encode(receiptInfoList)
    try jsonData.write(to: jsonFP)
}

// will create file if it doesn't exist!
// throws only when a critical error occurs
func loadJsonToMemory() throws -> [ReceiptInfo] {
    DLOG("loading json file")
    let decoder = JSONDecoder()
    let appDataDirFP: URL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    let jsonFP: URL = appDataDirFP.appending(path: "data.json")
    
    // this doesn't cause a race condition because we assume only one instance of the app is running at any time
    let fileExists = FileManager.default.fileExists(atPath: jsonFP.path)
    
    // create a blank file and return
    if !fileExists {
        DLOG("creating new json file")
        let encoder = JSONEncoder()
        let receiptInfoList: [ReceiptInfo] = []
        let jsonData = try encoder.encode(receiptInfoList)
        try jsonData.write(to: jsonFP)
        return receiptInfoList
    }
    
    let jsonData = try Data(contentsOf: jsonFP)
    let receiptInfoList = try decoder.decode([ReceiptInfo].self, from: jsonData)
    DLOG("got receiptInfo from disk: \(String(data: jsonData, encoding: .utf8)!)")
    return receiptInfoList
}

struct ReceiptInfo: Identifiable, Codable {
    var id = UUID() // must be `var` for Codable to work properly even though it doesn't change once set
    var summary: ReceiptSummary
    var details: ReceiptDetail
}

extension ReceiptInfo {
    init(){
        summary = ReceiptSummary()
        details = ReceiptDetail(merchant: Merchant(), items: [Item()])
    }
}

struct ReceiptSummary: Identifiable, Codable {
    var id = UUID()
//    let merchant_id: Int
    var merchant_name: String = ""
//    let merchant: Merchant
    var total_cost_including_tax: Double = 0.0
    var tax: Double = 1.37
    var time_purchased: Date = Date()
}

struct ReceiptDetail: Codable {
    var merchant: Merchant
    var items: [Item]
}

struct Merchant: Codable {
    var name: String = ""
    var address: String = ""
    var phone: String = ""
}

struct Item: Identifiable, Codable {
    var id = UUID()
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



class ReceiptStore: ObservableObject {
    @Published var fakeData = syntheticData()
    
    /// DO NOT MUTATE THIS, use createReceiptNew(), updateReceipt(), etc.
    /// initialzed in `Receipt_GobblerApp.swift:loadReceiptStore`
    @Published var receiptsDict: [UUID: ReceiptInfo] = [:]
    
    /// Call this every time the receipts are created, updated, or deleted
    func onModelUpdated(commitChanges: Bool = true) {
        // dump receipts to json
        // could maybe do this asyncronously (but be aware of race conditions)
        if !USE_FAKE_RECEIPT_DATA && commitChanges {
            do {
                try dumpMemoryToJson(Array(receiptsDict.values))
                DLOG("saved data to file")
            } catch {
                DLOG("[!] failed to write data to file")
            }
        }
    }
    
    func createReceiptNew(newReceiptInfo: ReceiptInfo){
        receiptsDict[newReceiptInfo.id] = newReceiptInfo
        onModelUpdated()
    }
    
    func readReceipt(id: UUID) -> ReceiptInfo{
        //needs to handle error when id doesnt exist
        return receiptsDict[id]!
    }

    /// If you provide `commitChanges: false` you must manually call onModelUpdated() at some later
    /// point to commit the changes.
    func updateReceipt(newReceiptInfo: ReceiptInfo, commitChanges: Bool = true) {
        receiptsDict[newReceiptInfo.id] = newReceiptInfo
        onModelUpdated(commitChanges: commitChanges)
    }
    
    func deleteReceipt(id: UUID){
        //maybe explore remove()
        receiptsDict[id] = nil
        onModelUpdated()
    }
    
    func deleteMultipleReceipts(ids: [UUID]) {
        // dictionary doesn't have a method to delete/set multiple at once AFAIK
        for id in ids {
            receiptsDict[id] = nil
        }
        onModelUpdated()
    }
    
    
    // Computed property to get the total spend for the current month
    var totalSpendThisMonth: Double {
        let calendar = Calendar.current
        let currentMonth = calendar.component(.month, from: Date())
        let currentYear = calendar.component(.year, from: Date())

        return receiptsDict.values.filter { receipt in
            let receiptMonth = calendar.component(.month, from: receipt.summary.time_purchased)
            let receiptYear = calendar.component(.year, from: receipt.summary.time_purchased)
            return receiptMonth == currentMonth && receiptYear == currentYear
        }.reduce(0) { total, receipt in
            total + receipt.summary.total_cost_including_tax
        }
    }
    
    struct StoreVisit: Identifiable {
        let id = UUID()
        let StoreName: String
        let visitCount: Int
    }
    
    var storesVisited: [StoreVisit] {
        var visitCounts: [String: Int] = [:]

        // Count the visits for each merchant
        for receipt in receiptsDict.values {
            let merchantName = receipt.summary.merchant_name
            visitCounts[merchantName, default: 0] += 1
        }

        // Convert the dictionary to an array of StoreVisit
        return visitCounts.map { StoreVisit(StoreName: $0.key, visitCount: $0.value) }
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
                    Item(name: "Bananananananana", unitPrice: 0.58, quantity: 6),
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



