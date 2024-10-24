import SwiftUI

struct HomeView: View {
    @State private var searchText: String = ""
    @ObservedObject var receiptStore = ReceiptStore.shared // Observing ReceiptStore for updates
    
    var body: some View {
        NavigationStack {
            VStack {
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
                        NavigationLink(destination: NewReceiptView()) {
                            Text("New Receipt")
                                .font(.title)
                                .frame(width: geometry.size.width * 0.8) // Fixed width based on available space
                                .padding()
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
    
                        // Previous Receipt Button
                        NavigationLink(destination: PreviousReceiptsView()) {
                            Text("Previous Receipt")
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
            .navigationTitle("Receipts")
        }
        

    }
}

struct ContentView: View {
    @State private var selectedTab = "home"

    var body: some View {
        
        TabView(selection: $selectedTab) {
            HomeView().tabItem{Label("Home", systemImage: "house.fill")}.tag("home")
        }

    }
}

// A custom search bar using UIViewRepresentable to integrate UISearchBar into SwiftUI
struct SearchBar: UIViewRepresentable {
    @Binding var text: String

    class Coordinator: NSObject, UISearchBarDelegate {
        @Binding var text: String

        init(text: Binding<String>) {
            _text = text
        }

        func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
            text = searchText
        }
    }

    func makeCoordinator() -> Coordinator {
        return Coordinator(text: $text)
    }

    func makeUIView(context: Context) -> UISearchBar {
        let searchBar = UISearchBar(frame: .zero)
        searchBar.delegate = context.coordinator
        return searchBar
    }

    func updateUIView(_ uiView: UISearchBar, context: Context) {
        uiView.text = text
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
