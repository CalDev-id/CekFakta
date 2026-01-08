//
//  CekFaktaApp.swift
//  CekFakta
//
//  Created by Heical Chandra on 24/11/25.
//

import SwiftUI
import SwiftData

@main
struct CekFaktaApp: App {
//    var sharedModelContainer: ModelContainer = {
//        let schema = Schema([
//            Item.self,
//        ])
//        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
//        
//        do {
//            return try ModelContainer(for: schema, configurations: [modelConfiguration])
//        } catch {
//            fatalError("Could not create ModelContainer: \(error)")
//        }
//    }()
    init() {
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor.systemBackground
        
        UITabBar.appearance().standardAppearance = appearance
        UITabBar.appearance().scrollEdgeAppearance = appearance
    }
    
    // 🔥 GLOBAL STATE
    @StateObject private var auth = AuthManager()
    @StateObject private var profile = ProfileManager()
    @StateObject private var news = NewsViewModel()
    
    @StateObject private var router = Router()
    @StateObject private var predictionStore = PredictionStore()
    
    var body: some Scene {
        WindowGroup {
            NavigationStack(path: $router.navPath){
                RootView()
                    .navigationDestination(for: Router.Destination.self) { destination in
                        switch destination {
                        case .detailNews(let id):
                            DetailNews(newsId: id)
                        case .predictWithLink:
                            PredictWithLink()
                        case .predictWithClaim:
                            PredictWithClaim()
                        case .predictWithNews:
                            PredictWithNews()
                        case .predictResult:
                            PredictResult()
                        }
                    }
            }
            .environmentObject(auth)
            .environmentObject(profile)
            .environmentObject(router)
            .environmentObject(predictionStore)
            .environmentObject(news)
        }
//        .modelContainer(sharedModelContainer)
    }
}
