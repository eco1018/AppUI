//
//  AppUIApp.swift
//  AppUI
//
//  Created by Ella A. Sadduq on 5/31/25.
//

import SwiftUI
import SwiftData
import FirebaseCore // ⬅️ Add this line

@main
struct AppUIApp: App {
    // Initialize Firebase in init
    init() {
        FirebaseApp.configure()
    }

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
            ContentView()
        }
        .modelContainer(sharedModelContainer)
    }
}
