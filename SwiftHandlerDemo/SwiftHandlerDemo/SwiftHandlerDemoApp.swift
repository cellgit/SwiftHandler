//
//  SwiftHandlerDemoApp.swift
//  SwiftHandlerDemo
//
//  Created by admin on 2024/8/26.
//

import SwiftUI
import SwiftData

@main
struct SwiftHandlerDemoApp: App {
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
            TestContentView()
        }
        .modelContainer(sharedModelContainer)
    }
}
