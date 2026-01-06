import SwiftUI

struct ContentView: View {
    @State private var isSelected: Int = 1
    @EnvironmentObject var auth: AuthManager

    var body: some View {
        TabView(selection: $isSelected) {
            HomeScreen()
                .tag(1)
                .tabItem {
                    Image(systemName: "house")
                    Text("Home")
                }

            PredictView()
                .tag(2)
                .tabItem {
                    Image(systemName: "magnifyingglass")
                    Text("Check")
                }

            ChatView()
                .tag(3)
                .tabItem {
                    Image(systemName: "message")
                    Text("Chat")
                }

            ProfileView()
                .tag(4)
                .tabItem {
                    Image(systemName: "person.fill")
                    Text("Profile")
                }
        }
        .background(.black)
        .accentColor(.red)
    }
}

#Preview {
    ContentView()
}
