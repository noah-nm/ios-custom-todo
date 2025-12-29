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

    // New folder state
    @State private var showingNewFolderSheet = false
    @State private var newFolderName = ""
    @State private var newFolderDescription = ""

    // New task state
    @State private var showingNewTaskSheet = false
    @State private var newTaskName = ""
    @State private var newTaskDescription = ""
    @State private var newTaskDueDate = Date()
    @State private var newTaskPriority: Priority = .medium

    @Environment(\.modelContext) private var modelContext

    var body: some View {
        List {
            listContent
        }
        .navigationTitle(folder.name)
        .navigationSubtitle(folder.details ?? "")
        .toolbar {
            ToolbarItemGroup(placement: .topBarTrailing) {
                Button {
                    showingNewTaskSheet = true
                } label: {
                    Image(systemName: "checkmark.circle.badge.plus")
                }

                Button {
                    showingNewFolderSheet = true
                } label: {
                    Image(systemName: "folder.badge.plus")
                }
            }
        }
        .sheet(isPresented: $showingNewFolderSheet) {
            newFolderSheet
        }
        .sheet(isPresented: $showingNewTaskSheet) {
            newTaskSheet
        }
    }

    // MARK: - List Content
    @ViewBuilder
    private var listContent: some View {
        if !folder.children.isEmpty {
            Section("Subfolders") {
                ForEach(folder.children) { child in
                    NavigationLink {
                        FolderDetailView(folder: child)
                    } label: {
                        HStack {
                            Image(systemName: "folder.fill")
                                .foregroundStyle(.blue)
                            Text(child.name)
                        }
                    }
                }
            }
        }

        if !folder.tasks.isEmpty {
            Section("Tasks") {
                ForEach(folder.tasks) { task in
                    NavigationLink {
                        TaskDetailView(task: task)
                    } label: {
                        HStack {
                            Image(systemName: task.isDone ? "checkmark.square.fill" : "square")
                                .foregroundStyle(task.isDone ? .green : .gray)

                            Text(task.name)
                                .strikethrough(task.isDone)
                        }
                    }
                }
            }
        }

        if folder.children.isEmpty && folder.tasks.isEmpty {
            Text("No items in this folder.")
        }
    }

    // MARK: - New Folder Sheet
    private var newFolderSheet: some View {
        NavigationStack {
            Form {
                Section("Folder Name") {
                    TextField("Enter folder name", text: $newFolderName)
                }

                Section("Folder Description") {
                    TextField("Enter folder description", text: $newFolderDescription)
                }
            }
            .navigationTitle("New Folder")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        showingNewFolderSheet = false
                        newFolderName = ""
                        newFolderDescription = ""
                    }
                }

                ToolbarItem(placement: .confirmationAction) {
                    Button("Create") {
                        createFolder()
                    }
                    .disabled(newFolderName.isEmpty)
                }
            }
        }
    }

    // MARK: - New Task Sheet
    private var newTaskSheet: some View {
        NavigationStack {
            Form {
                Section("Task Name") {
                    TextField("Enter task name", text: $newTaskName)
                }

                Section("Task Description") {
                    TextField("Enter task description", text: $newTaskDescription)
                }

                Section("Due Date") {
                    DatePicker("Date", selection: $newTaskDueDate)
                }

                Section("Priority") {
                    Picker("Priority", selection: $newTaskPriority) {
                        ForEach(Priority.allCases, id: \.self) { level in
                            HStack {
                                Circle()
                                    .frame(width: 10, height: 10)
                                Text(level.rawValue.capitalized)
                            }
                            .tag(level)
                        }
                    }
                }
            }
            .navigationTitle("New Task")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        showingNewTaskSheet = false
                        resetTaskFields()
                    }
                }

                ToolbarItem(placement: .confirmationAction) {
                    Button("Create") {
                        createTask()
                    }
                    .disabled(newTaskName.isEmpty)
                }
            }
        }
    }

    // MARK: - Create Folder
    private func createFolder() {
        let newFolder = Folder(
            name: newFolderName,
            details: newFolderDescription
        )

        newFolder.parent = folder
        folder.children.append(newFolder)

        newFolderName = ""
        newFolderDescription = ""
        showingNewFolderSheet = false
    }

    // MARK: - Create Task
    private func createTask() {
        let newTask = Task(
            name: newTaskName,
            details: newTaskDescription,
            dueDate: newTaskDueDate,
            priority: newTaskPriority
        )

        newTask.folders.append(folder)
        folder.tasks.append(newTask)

        resetTaskFields()
        showingNewTaskSheet = false
    }

    private func resetTaskFields() {
        newTaskName = ""
        newTaskDescription = ""
        newTaskDueDate = Date()
        newTaskPriority = .medium
    }
}

