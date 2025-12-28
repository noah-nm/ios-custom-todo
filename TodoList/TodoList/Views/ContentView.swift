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
                FolderDetailView(folder: root)
            } else {
                Text("Loading Root")
            }
        }
        .task {
            ensureRootFolder()
            
            if let root = rootFolder {
                seedSampleData(for: root)
            }
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
    
    private func seedSampleData(for root: Folder) {
        // Only seed folders if none exist
        if root.children.isEmpty {
            let school = Folder(name: "School")
            school.parent = root
            root.children.append(school)

            let programming = Folder(name: "Programming")
            programming.parent = root
            root.children.append(programming)
        }

        // Only seed tasks if none exist
        if root.tasks.isEmpty {
            let task1 = Task(name: "Finish homework")
            root.tasks.append(task1)
            task1.folders.append(root)

            let task2 = Task(name: "Buy groceries")
            root.tasks.append(task2)
            task2.folders.append(root)

            let task3 = Task(name: "Learn Swift")
            root.tasks.append(task3)
            task3.folders.append(root)
        }
    }
}

