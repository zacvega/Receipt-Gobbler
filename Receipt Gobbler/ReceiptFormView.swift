import SwiftUI


struct InputItemsGridView: View {
    @Binding var items: [Item]
    var body: some View {
        Grid {
            GridRow{
                Text("Item Name")
                Text("Unit Price")
                Text("Quantity")
                //                        Image(systemName: "globe")
            }
            .font(.headline)
            
            Divider()
            
            ForEach($items, id: \.id){ $item in
                GridRow{
                    TextField("Item Name", text: $item.name)
                    //                                    .foregroundColor(isFocused ? .blue: .black)
                    HStack(spacing: 2.0) {
                        Text("$")
                        TextField("Unit Price", value: $item.unitPrice, format: .number.precision(.fractionLength(2)))
                    }
                    TextField("Quantity", value: $item.quantity, format: .number)
                }
                
            }
        }
    }
}

struct InputItemsListView: View {
    @Binding var items: [Item]
    var body: some View {
        HStack {
            Text("Item Name")
            Spacer()
            //Divider()
            Text("Unit Price").frame(width: 9*10)
            Spacer()
            //Divider()
            Text("Count").frame(width: 5*10)
                
        }
        .font(.headline)
        //.multilineTextAlignment(.center)
        
        List($items, id:\.id, editActions: .delete){ i in
            HStack {
                TextField("Item Name", text: i.name)
                Divider()
                Text("$")
                    .padding(.trailing, -5.0)
                    
                TextField("Unit Price", value: i.unitPrice, format: .number.precision(.fractionLength(2)))
                    .frame(width: 9*10)
                Divider()
                TextField("Count", value: i.quantity, format: .number.precision(.fractionLength(2)))
                    .frame(width: 5*10)
            }
        }
    }
}

struct ReceiptFormView: View {
//    @State private var storeName: String = ""
//    @State private var merchantAddress: String = ""
//    @State private var merchantPhone: String = ""
    
    //@State private var merchantInfo: Merchant = Merchant()
    
    @Binding var newReceiptInfo: ReceiptInfo
//    @Binding var parentPath: [String]
    

    
    //used to update merchant name in both ReceiptSummary and ReceiptDetail instances
    private var combinedMerchantNameBinding: Binding<String> {
        Binding<String> (
            get: {
                return self.newReceiptInfo.summary.merchant_name
            },
            set: {
                userModifiedMerchantName in
                self.newReceiptInfo.summary.merchant_name = userModifiedMerchantName
                self.newReceiptInfo.details.merchant.name = userModifiedMerchantName
            }
        )
    }
    
    
//    @State private var totalCostIncludingTax: Double = 123.4567
//    @State private var tax: Double = 0.0
//    @State private var receiptDate: Date = Date() // Use for the date input
    @Environment(\.presentationMode) var presentationMode
    
//    @FocusState private var isFocused: Bool
    

    var body: some View {
        VStack(){
            Form {
                Section(header: Text("Receipt Summary")){
                    HStack {
                        Text("Merchant:")
                            .font(.headline)
                        TextField("Merchant Name", text: combinedMerchantNameBinding)
                    }

                    
                    HStack(spacing: 1.0) {
                        Text("Total\n(with tax): ")
                            .font(.headline)
                            .multilineTextAlignment(.center)
                        
                        Text("$")
                            
                        TextField(value: $newReceiptInfo.summary.total_cost_including_tax, format: .number.precision(.fractionLength(2))){
                            Text("Total Cost")
                                
                        }
                        .keyboardType(.decimalPad)
                        Divider()
                            .padding(.trailing, 5.0)
                            
                        
                        Text("Tax: ")
                            .font(.headline)
                        Text("$")
                        TextField("Tax", value: $newReceiptInfo.summary.tax, format: .number.precision(.fractionLength(2)))
                        .keyboardType(.decimalPad)
                    }
//                    HStack(spacing: 1.0) {
//                        Text("Tax: ")
//                            .font(.headline)
//                        Text("$")
//                        TextField("Tax", value: $tax, format: .number.precision(.fractionLength(2)))
//                        .keyboardType(.decimalPad)
//                    }
                    
                    
                    
                    DatePicker("Date Purchased:", selection: $newReceiptInfo.summary.time_purchased, displayedComponents: .date).font(.headline)
                }
                
                Section(header: Text("Merchant Info")) {
                    //Text("Store Information")
                    
                    TextField("Merchant Address", text: $newReceiptInfo.details.merchant.address)
                    TextField("Merchant Phone", text: $newReceiptInfo.details.merchant.phone)
                    
                }
                
                Section(header: Text("Items")){
                    //consider using a fixed-width view to make faster
                    //InputItemsGridView(items: $newReceiptInfo.details.items)
                    InputItemsListView(items: $newReceiptInfo.details.items)
                    
                    Button(action: {
                        newReceiptInfo.details.items.append(Item(name:"POP!"))
                    }
                    ) {
                        Label("Add item", systemImage: "plus.circle")
                    }
                }
                
            }
            
            
            //NavigationLink(destination: PreviousReceiptsView()) {
            //The button works but Does Not Navigate
            //TODO: display signs of success if no error is thrown, then navigate to past receipts list, then to detail
                Button(action: saveReceipt) {
                    Text("Save")
                        .font(.title3)
                        .fontWeight(.medium)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(30)
                }
            //}
                
            
//            Button(action: saveReceipt) {
//                Text("Save")
//                    .font(.title3)
//                    //.frame(maxWidth: .infinity)
//                    .fontWeight(.medium)
//                    .padding()
//                    .background(Color.blue)
//                    .foregroundColor(.white)
//                    .cornerRadius(20)
//            }
        }
        .navigationTitle("Input Form")
        .navigationBarTitleDisplayMode(.inline)
        
        
    }
    
    @EnvironmentObject var dataModel: ReceiptStore

    private func saveReceipt() {
        dataModel.createReceiptNew(newReceiptInfo: newReceiptInfo)
        
        // replace newReceiptInfo with a fresh object for later use (since NewReceiptView owns it and that view is never destroyed)
        newReceiptInfo = ReceiptInfo()
        
        //ReceiptStore.receiptsDict[newReceiptInfo.id] =  newReceiptInfo
//        guard let price = Double(price) else {
//            print("Invalid price")
//            return
//        }

//        let itemsArray = items.split(separator: ",").map { $0.trimmingCharacters(in: .whitespaces) }

        // Save receipt with the selected date
//        ReceiptStore.shared.addReceipt(storeName: storeName, items: itemsArray, price: price, date: receiptDate)
        
        // Go back to the previous screen
        presentationMode.wrappedValue.dismiss()
    }
}

struct ReceiptFormView_Previews: PreviewProvider {
    static var previews: some View {
        //NewReceiptView()
        ReceiptFormView(newReceiptInfo: NewReceiptView().$newReceiptInfo)
    }
}
