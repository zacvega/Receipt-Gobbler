import SwiftUI
import Charts

struct HomeView: View {
    @State private var searchText: String = ""
    @EnvironmentObject var dataModel: ReceiptStore
    
    @Binding var selectedTab: String
    
    var body: some View {
        NavigationStack {
            VStack {
                // Display total spend for the current month
                Text("Total Spend This Month")
                    .font(.headline)
                    .padding(.top, 20)

                Text("$\(dataModel.totalSpendThisMonth, specifier: "%.2f")")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.bottom, 20)

                // Search Bar
                SearchBar(text: $searchText)
                    .padding()
                Spacer()
                // GeometryReader to get the available width for buttons
                GeometryReader { geometry in
                    VStack {
                        Chart(dataModel.storesVisited){ visit in
                            BarMark(
                                x: .value("Store", visit.StoreName),  // X-axis: Store name
                                y: .value("Visit Count", visit.visitCount)  // Y-axis: Number of visits
                            )
                        }
                        .padding(.top, 20)
                        .padding(.bottom, 20)
//                        .frame(height: 500)
                    }
                    // add the following line back in if you think the chart is too large
//                    .frame(width: geometry.size.width, height: geometry.size.height * 0.80)
                    
                }
//                .padding(.top, 20)

//                Spacer()
            }
            .padding()
            .navigationTitle("Home")
        }
        

    }
}

struct HomeView_Previews: PreviewProvider {
    @State static var _selectedTab: String = "home"
    @StateObject static var dataModel: ReceiptStore = loadFakeReceiptStore()
    
    static var previews: some View {
        
        HomeView(selectedTab: $_selectedTab)
            .environmentObject(dataModel)
    }
}
