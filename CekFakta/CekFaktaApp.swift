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
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Item.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            NavigationStack {
                ContentView()
            }
        }
        .modelContainer(sharedModelContainer)
    }
}
