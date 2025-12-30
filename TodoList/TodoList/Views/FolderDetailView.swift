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

    // new folder state
    @State private var showingNewFolderSheet = false
    @State private var newFolderName = ""
    @State private var newFolderDescription = ""
    
    // new task state
    @State private var showingNewTaskSheet = false
    @State private var newTaskName = ""
    @State private var newTaskDescription = ""
    @State private var newTaskDueDate = Date()
    @State private var newTaskPriority: Priority = .medium
    
    @State private var selectedTask: Task?

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
        .navigationDestination(item: $selectedTask) { task in
            TaskDetailView(task: task)
        }
    }

    // MARK: - List Content
    // subfolder list
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
        
        // task list
        if !folder.tasks.isEmpty {
            Section("Tasks") {
                ForEach(folder.tasks) { task in
                    HStack {
                        Image(systemName: task.isDone ? "checkmark.square.fill" : "square")
                            .foregroundStyle(task.isDone ? .green : .gray)

                        VStack(alignment: .leading, spacing: 2) {
                            Text(task.name)
                                .strikethrough(task.isDone)

                            if let due = task.dueDate {
                                Text("Due: \(due, style: .date)")
                                    .font(.subheadline)
                                    .foregroundStyle(.secondary)
                                    .strikethrough(task.isDone)
                            }
                        }

                        Spacer()

                        if task.isDone {
                            Button {
                                withAnimation {
                                    folder.tasks.removeAll { $0.id == task.id}
                                    
                                    modelContext.delete(task)
                                    
                                    try? modelContext.save()
                                }
                            } label: {
                                Image(systemName: "trash")
                                    .foregroundStyle(.red)
                            }
                            .buttonStyle(.borderless)
                        }

                        Spacer()

                        Text(task.priority.rawValue.capitalized)
                            .fontWeight(.medium)
                            .padding(.vertical, 6)
                            .padding(.horizontal, 10)
                            .background(priorityColor(task.priority))
                            .clipShape(Capsule())
                    }
                    .contentShape(Rectangle())
                    .onTapGesture {
                        selectedTask = task
                    }

                    // swipe right to mark task as done
                    .swipeActions(edge: .leading, allowsFullSwipe: true) {
                        Button {
                            task.isDone = true
                        } label: {
                            EmptyView()
                        }
                    }
                    // swipe left to mark task as not done
                    .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                        Button {
                            task.isDone = false
                        } label: {
                            EmptyView()
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
    
    private func priorityColor(_ p: Priority) -> Color {
        switch p {
        case .low: return .blue.opacity(0.25)
        case .medium: return .yellow.opacity(0.35)
        case .high: return .red.opacity(0.35)
        }
    }
}

