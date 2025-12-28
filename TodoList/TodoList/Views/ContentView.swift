//
//  ContentView.swift
//  TodoList
//
//  Created by Noah Mills on 2025-12-26.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Folder.name) private var folders: [Folder]

    var body: some View {
        // Ensure root folder exists and load it
        NavigationStack {
            if let root = rootFolder {
                Text("Root Ready")
            } else {
                Text("Loading Root")
            }
        }
        .task {
            ensureRootFolder()
        }
    }

    private var rootFolder: Folder? {
        folders.first(where: { $0.name == "Root" && $0.parent == nil})
    }
    
    private func ensureRootFolder() {
        if rootFolder == nil {
            let root = Folder(name: "Root")
            modelContext.insert(root)
        }
    }
}

