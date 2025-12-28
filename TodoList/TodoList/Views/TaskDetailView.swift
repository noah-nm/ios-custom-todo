//
//  TaskDetailView.swift
//  TodoList
//
//  Created by Noah Mills on 2025-12-28.
//

import SwiftUI
import SwiftData

struct TaskDetailView: View {
    let task: Task
    
    var body: some View {
            List {
                Section {
                    HStack {
                        if task.isDone {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundStyle(.green)
                        } else {
                            Image(systemName: "circle")
                                .foregroundStyle(.gray)
                        }
                        
                        Text(task.name)
                            .font(.title3)
                            .fontWeight(.semibold)
                    }
                }
                
                Section("Priority") {
                    Text(task.priority.rawValue.capitalized)
                        .fontWeight(.medium)
                        .padding(.vertical, 6)
                        .padding(.horizontal, 10)
                        .background(priorityColor(task.priority))
                        .clipShape(Capsule())
                }
                
                if let due = task.dueDate {
                    Section("Due Date") {
                        Text(due, style: .date)
                            .font(.body)
                    }
                }
                
                if let details = task.details, !details.isEmpty {
                    Section("Details") {
                        Text(details)
                            .font(.body)
                            .foregroundStyle(.secondary)
                    }
                }
            }
            .navigationTitle("Task Details")
        }
        
        private func priorityColor(_ p: Priority) -> Color {
            switch p {
            case .low: return .blue.opacity(0.25)
            case .medium: return .yellow.opacity(0.35)
            case .high: return .red.opacity(0.35)
            }
        }
}
