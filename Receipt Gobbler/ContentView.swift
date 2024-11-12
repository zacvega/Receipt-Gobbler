import SwiftUI

struct ContentView: View {
    @State private var selectedTab = "home"

    var body: some View {
        
        TabView(selection: $selectedTab) {
            HomeView().tabItem {
                Label("Home", systemImage: "house")
            }.tag("home")
            
            NewReceiptView().tabItem {
                Label("New Receipt", systemImage: "doc.badge.plus")
            }.tag("new receipts")
            
            PreviousReceiptsView().tabItem {
                Label("Past Receipts", systemImage: "folder")
            }.tag("past receipts")
            
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
