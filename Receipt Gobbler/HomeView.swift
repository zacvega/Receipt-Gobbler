import SwiftUI

struct HomeView: View {
    @State private var searchText: String = ""
    @ObservedObject var receiptStore = ReceiptStore.shared // Observing ReceiptStore for updates
    
    @Binding var selectedTab: String
    
    var body: some View {
        NavigationStack {
            VStack {
//                Title(text: "Home")
                
                // Display total spend for the current month
                Text("Total Spend This Month")
                    .font(.headline)
                    .padding(.top, 20)

                Text("$\(receiptStore.totalSpendThisMonth, specifier: "%.2f")")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.bottom, 20)

                // Search Bar
                SearchBar(text: $searchText)
                    .padding()
                
                // GeometryReader to get the available width for buttons
                GeometryReader { geometry in
                    VStack {
                        // New Receipt Button
                        Button(action: {
                            selectedTab = "new_receipt"
                        }) {
                            Text("New Receipt")
                                .font(.title)
                                .frame(width: geometry.size.width * 0.8) // Fixed width based on available space
                                .padding()
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
    
                        // Previous Receipt Button
                        Button(action: {
                            selectedTab = "past_receipts"
                        }) {
                            Text("Past Receipts")
                                .font(.title)
                                .frame(width: geometry.size.width * 0.8) // Fixed width based on available space
                                .padding()
                                .background(Color.green)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                    }
                    .frame(width: geometry.size.width, height: geometry.size.height) // Ensuring buttons align properly
                }
                .padding(.top, 20)

                Spacer()
            }
            .padding()
            .navigationTitle("Home")
        }
        

    }
}

struct HomeView_Previews: PreviewProvider {
    @State static var _selectedTab: String = "home"
    
    static var previews: some View {
        HomeView(selectedTab: $_selectedTab)
    }
}
