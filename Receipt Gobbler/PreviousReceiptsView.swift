import SwiftUI

struct ReceiptSummaryRowView: View{
    var summary: ReceiptSummary
    var body: some View{
        VStack(alignment: .leading, spacing: 3.0){
            HStack{
                //Image(systemName:"")
                Text(summary.merchant_name)
                    .foregroundColor(.primary)
                    .font(.title2)
                    .multilineTextAlignment(.center)
                    .padding(.vertical)
            }
            
            HStack(spacing: 2.0){
                Image(systemName:"dollarsign.circle")
                Text(String(format: "%.2f", summary.total_cost_including_tax))
                    .font(.headline)
                    .fontWeight(.regular)
                    
//                Text(summary.total_cost_including_tax, format: .number.precision(.fractionLength(2)))
//                    .font(.subheadline)
                Spacer()
                Image(systemName:"calendar.badge.clock")
                Text(summary.time_purchased, format:.dateTime.day().month().weekday().year())
                    .font(.headline)
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
//    @State var summaries = ReceiptStore.shared.fakeData.summaries

    //var details: ReceiptDetail

//    @State var fullInfos = ReceiptStore.shared.fakeData.fullInfo
    @Binding var receiptsDict: Dictionary<UUID,ReceiptInfo>
    

    var body: some View{
        NavigationStack{
            List{
                ForEach(Array(receiptsDict.values)) { i in
                    NavigationLink(destination: ReceiptDetailsView(fullInfo: i)){
                        ReceiptSummaryRowView(summary: i.summary)
                    }
                }
            }
            .navigationTitle("Past Receipts")
        }
    }
    
    
}


struct PreviousReceiptsView: View {
//    @ObservedObject var receiptStore = ReceiptStore.shared
    @EnvironmentObject var dataModel: ReceiptStore


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
            ReciptSummaryListView(receiptsDict: $dataModel.receiptsDict)
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
        //ScrollView{
            VStack(){
                Text(fullInfo.details.merchant.name).font(.title)
                Text(fullInfo.details.merchant.address).font(.title3).foregroundColor(.secondary).multilineTextAlignment(.center)
                Text(fullInfo.details.merchant.phone).font(.title3).foregroundColor(.secondary).frame(height: 10.0)
                Text(fullInfo.summary.time_purchased.formatted(date:.abbreviated, time: .omitted)).font(.title2)
                Divider()
                    .padding(.bottom, 30.0)
                //
                //            Spacer()
                //                .frame(height: 100)
                ScrollView{
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
                }
                Divider()
                
                HStack(spacing: 2.0) {
                    Spacer()
                    Text("Tax:  $") .font(.headline)
                    Text(fullInfo.summary.tax, format: .number.precision(.fractionLength(2)))
                }
                
                HStack(spacing: 2.0){
                    Spacer()
                    Text("Total (with tax):  $")
                        .font(.headline)
                    Text(fullInfo.summary.total_cost_including_tax, format: .number.precision(.fractionLength(2)))
                }
                
                Spacer()
                
            }
            .padding(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
        //}
    }
    
    
}





struct pastReceipts_preview: PreviewProvider{
    static var previews: some View{
        @StateObject var dataModel: ReceiptStore = ReceiptStore()
        
        PreviousReceiptsView()
            .environmentObject(dataModel)
    }
}
