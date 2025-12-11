//
//import SwiftUI
//
//struct ContentView: View {
//    @State private var tabSelected: Tab = .house
//    
//    init() {
//        UITabBar.appearance().isHidden = true
//    }
//    
//    var body: some View {
//        //        NavigationView {
//        ZStack {
//            VStack {
//                TabView(selection: $tabSelected) {
//                    ForEach(Tab.allCases, id: \.self) { tab in
//                        getView(for: tab)
//                            .tag(tab)
//                    }
//                }
//                .padding(.bottom, 80)
//            }
//            VStack {
//                Spacer()
//                CustomTabBar(selectedTab: $tabSelected)
//            }
//        }
//        //        }.navigationBarBackButtonHidden(true)
//    }
//    
//    func getView(for tab: Tab) -> some View {
//        switch tab {
//        case .house:
//            return AnyView(HomeScreen())
//        case .message:
//            return AnyView(PredictView())
//        case .book:
//            return AnyView(ChatView())
//        case .bookmark:
//            return AnyView(DataView())
//            
//        }
//    }
//}
//    
//    #Preview {
//        ContentView()
//}
import SwiftUI

struct ContentView: View {
    @State private var isSelected: Int = 1

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

            DataView()
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

#Preview { ContentView() }
