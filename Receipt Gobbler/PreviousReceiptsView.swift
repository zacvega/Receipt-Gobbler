import SwiftUI

struct ReceiptSummaryRowView: View{
    var summary: ReceiptSummary
    var body: some View{
        VStack(alignment: .leading, spacing: 3.0){
            Text(summary.merchant_name)
                .foregroundColor(.primary)
                .font(.headline)
                .multilineTextAlignment(.center)
            HStack(spacing: 2.0){
                Text("$")
                Text(summary.total_cost, format: .number.precision(.fractionLength(2)))
                    .font(.subheadline)
                Spacer()
                Text(summary.time_purchased, format:.dateTime.day().month().weekday().year())
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    
            }
        }
        
    }
}

struct ReciptSummaryListView: View {
    //    var myCalendar = Calendar(identifier: .gregorian)
        //    myCalendar.date(from: DateComponents(year: 2024, month: 1, day: 1))
    //    var myFormatter: DateFormatter = DateFormatter()
    //    myFormatter.locale = Locale(identifier: "en_US_POSIX")
    //    myFormatter.dateFormat = "yyyy/MM/dd"
    //    var d = myFormatter.date(from: "2016/10/08")
    
    //some synthetic data
    @State var summaries = ReceiptStore.shared.data.summaries

    @State var details = ReceiptStore.shared.data.details

    @State var fullInfos = ReceiptStore.shared.data.fullInfo
        
    

    var body: some View{
        NavigationView{
            List{
                ForEach(fullInfos) { i in
                    NavigationLink(destination: ReceiptDetailsView(fullInfo: i)){
                        ReceiptSummaryRowView(summary: i.summary)
                    }
                }
            }
        }
    }
}


struct PreviousReceiptsView: View {
    @ObservedObject var receiptStore = ReceiptStore.shared

//    var body: some View {
//        List {
//            ForEach(receiptStore.receipts) { receipt in
//                VStack(alignment: .leading) {
//                    Text(receipt.storeName)
//                        .font(.headline)
//                    Text("Items: \(receipt.items.joined(separator: ", "))")
//                    Text("Price: $\(receipt.price, specifier: "%.2f")")
//                    Text("Date: \(receipt.date, formatter: dateFormatter)") // Display the date
//                }
//            }
//        }
//        .navigationTitle("Previous Receipts")
//    }
    
    var body: some View {
        VStack{
            //Text("Past Receipts").font(.title)
            ReciptSummaryListView()
        }
    }

    // Formatter to display the date in a readable format
//    private var dateFormatter: DateFormatter {
//        let formatter = DateFormatter()
//        formatter.dateStyle = .medium  // Adjust the date format as needed (medium, long, short, etc.)
//        formatter.timeStyle = .none  // No time component
//        return formatter
//    }
}

struct ReceiptDetailsView: View {
    var fullInfo: ReceiptInfo
    var body: some View{
        VStack(){
            Text(fullInfo.details.merchant.name).font(.title)
            Text(fullInfo.details.merchant.address).font(.title3).foregroundColor(.secondary).multilineTextAlignment(.center)
            Text(fullInfo.details.merchant.phone).font(.title3).foregroundColor(.secondary).frame(height: 10.0)
            Text(fullInfo.summary.time_purchased.formatted(date:.abbreviated, time: .omitted)).font(.title2)
            Divider()
            
            Spacer()
                .frame(height: 100)
            Grid{
                GridRow {
                    Text("Item Name")
                    Spacer()
                    Text("Unit Price")
                    Spacer()
                    Text("Quantity")
                }
                .font(.headline)
                .gridCellUnsizedAxes(.vertical)
                Divider()
                
                ForEach(fullInfo.details.items){
                    item in GridRow{
                        Text(item.name)
                        Spacer()
                        Text(item.unitPrice, format: .number.precision(.fractionLength(2)))
                        Spacer().gridCellUnsizedAxes(.horizontal)
                        Text(item.quantity, format: .number.precision(.fractionLength(2)))
                    }.gridCellUnsizedAxes(.vertical)


                }

            }
            Divider()
            
            
            HStack(spacing: 2.0){
                Spacer()
                Text("Total:  $").font(.headline)
                Text(fullInfo.summary.total_cost, format: .number.precision(.fractionLength(2)))
            }
            
            Spacer()
                
            
            
        }
        .padding(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
    }
    
    
}





struct pastReceipts_preview: PreviewProvider{
    static var previews: some View{
        PreviousReceiptsView()
    }
}
