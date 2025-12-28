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
        NavigationStack {
            List {
                ForEach(folders) { folder in
                    Text(folder.name)
                }
            }
            .navigationTitle("Folders")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Add Folder") {
                        addFolder()
                    }
                }
            }
        }
    }

    private func addFolder() {
        let folder = Folder(name: "New Folder")
        modelContext.insert(folder)
    }
}

