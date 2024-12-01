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

/// Generaates Bindings that will automatically update the ReceiptStore any time receipts are mutated.
func receiptsDictToBindings(_ receiptStore: ReceiptStore) -> [Binding<ReceiptInfo>] {
    var bindings: [Binding<ReceiptInfo>] = []
    for receipt in receiptStore.receiptsDict.values {
        bindings.append(.init(get: {
            return receipt
        }, set: { receipt in
//            DLOG("mutated receipts via binding")
            // this will also commit changes to disk, so try not to mutate the receipts
            // directly too often
            receiptStore.updateReceipt(newReceiptInfo: receipt, commitChanges: true)
        }))
    }
    return bindings
}

struct ReciptSummaryListView: View {
    @ObservedObject var receiptStore: ReceiptStore // passed in
    
    var body: some View {
        let receipts = receiptsDictToBindings(receiptStore)
        
        return NavigationStack{
            List {
                // the receipt bindings passed in here are mutable, but you shouldn't mutate them too often
                // because they trigger immediate to-disk commits (use temporary variables for textboxes and
                // such if necessary and only mutate when changes are confirmed)
                ForEach(receipts, id:\.id) { i in
                    NavigationLink(destination: ReceiptDetailsView(fullInfo: i)){
                        ReceiptSummaryRowView(summary: i.wrappedValue.summary)
                    }
                }
                .onDelete { indexSet in
                    // convert indeces to UUIDs
                    var receiptsToDelete: [UUID] = []
                    for i in indexSet {
                        receiptsToDelete.append(receipts[i].id)
                    }
                    
                    // remove the receipts properly
                    receiptStore.deleteMultipleReceipts(ids: receiptsToDelete)
                }
            }
            .navigationTitle("Past Receipts")
        }
    }
}


struct PreviousReceiptsView: View {
    @EnvironmentObject var dataModel: ReceiptStore
    
    var body: some View {
        VStack{
            ReciptSummaryListView(receiptStore: dataModel)
        }
    }
}

struct ReceiptDetailsView: View {
    @Environment(\.editMode) private var editMode

    @Binding var fullInfo: ReceiptInfo
    var body: some View{
        //ScrollView{
            VStack(){
                Text(fullInfo.details.merchant.name).font(.title)
                Text(fullInfo.details.merchant.address).font(.title3).foregroundColor(.secondary).multilineTextAlignment(.center)
                Text(fullInfo.details.merchant.phone).font(.title3).foregroundColor(.secondary)//.frame(height: 10.0)
                Text(fullInfo.summary.time_purchased.formatted(date:.abbreviated, time: .omitted)).font(.title3).padding(.top, 1.0)
                Divider()
                    .padding(.bottom, 20.0)
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
            .toolbar{
                Button(action: {
                    self.editMode?.wrappedValue.toggle()
                }) {
                      Label("Edit", systemImage: self.editMode?.wrappedValue == .active ? "checkmark.square" : "square.and.pencil" )
//                        .foregroundColor(.white)
//                        .background(Color.blue)
//                        .cornerRadius(10)
                    Text(self.editMode?.wrappedValue == .active ? "Done" : "Edit")
                        .padding(.leading, -20.0)
                        .frame(width: 45.0)
                    }
            }
            .padding(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
        //}
    }
    
}

extension EditMode {
    mutating func toggle(){
        self = self == .active ? .inactive : .active
    }
}





struct pastReceipts_preview: PreviewProvider{
    @StateObject static var dataModel: ReceiptStore = ReceiptStore()
    static var previews: some View{
        PreviousReceiptsView()
            .environmentObject(dataModel)
    }
}
