//
//  FolderDetailView.swift
//  TodoList
//
//  Created by Noah Mills on 2025-12-28.
//

import SwiftUI
import SwiftData

struct FolderDetailView: View {
    let folder: Folder
    
    var body: some View {
        List {
            if !folder.children.isEmpty {
                Section("Subfolders") {
                    ForEach(folder.children) { child in
                        NavigationLink {
                            FolderDetailView(folder: child)
                        } label : {
                            HStack {
                                Image(systemName: "folder.fill")
                                    .foregroundColor(.blue)
                                
                                Text(child.name)
                            }
                        }
                    }
                }
            }
            
            if !folder.tasks.isEmpty {
                Section("Tasks") {
                    ForEach(folder.tasks) { task in
                        HStack {
                            if task.isDone {
                                Image(systemName: "checkmark.square.fill")
                                    .foregroundStyle(.green)
                            } else {
                                Image(systemName: "square")
                                    .foregroundStyle(.gray)
                            }
                            
                            if !task.isDone {
                                Text(task.name)
                            } else {
                                Text(task.name).strikethrough()
                            }
                        }
                    }
                }
            }
            
            if folder.children.isEmpty && folder.tasks.isEmpty {
                Text("No items in this folder.")
            }
        }
    }
}
