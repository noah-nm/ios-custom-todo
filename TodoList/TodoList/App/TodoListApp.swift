//
//  TodoListApp.swift
//  TodoList
//
//  Created by Noah Mills on 2025-12-26.
//

import SwiftUI
import SwiftData

@main
struct TodoListApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Task.self,
            Folder.self,
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
                .preferredColorScheme(ColorScheme.dark)
        }
        .modelContainer(sharedModelContainer)
    }
}
