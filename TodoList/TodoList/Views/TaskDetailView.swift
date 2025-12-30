import SwiftUI
import SwiftData

struct TaskDetailView: View {
    @Environment(\.modelContext) private var modelContext
    
    let task: Task
    @State private var isEditing = false
    
    var body: some View {
        List {
            
            // MARK: Status + Name
            Section {
                HStack {
                    Button {
                        task.isDone.toggle()
                    } label: {
                        Image(systemName: task.isDone ? "checkmark.circle.fill" : "circle")
                            .foregroundStyle(task.isDone ? .green : .gray)
                            .font(.system(size: 26))
                    }
                    .buttonStyle(.plain)

                    if isEditing {
                        TextField("Task Name", text: Binding(
                            get: { task.name },
                            set: { task.name = $0 }
                        ))
                        .font(.title3)
                        .fontWeight(.semibold)
                    } else {
                        Text(task.name)
                            .font(.title3)
                            .fontWeight(.semibold)
                    }
                }
            }
            
            // MARK: Priority
            Section("Priority") {
                if isEditing {
                    Picker("Priority", selection: Binding(
                        get: { task.priority },
                        set: { task.priority = $0 }
                    )) {
                        ForEach(Priority.allCases, id: \.self) { level in
                            Text(level.rawValue.capitalized).tag(level)
                        }
                    }
                } else {
                    Text(task.priority.rawValue.capitalized)
                        .fontWeight(.medium)
                        .padding(.vertical, 6)
                        .padding(.horizontal, 10)
                        .background(priorityColor(task.priority))
                        .clipShape(Capsule())
                }
            }
            
            // MARK: Due Date
            Section("Due Date") {
                if isEditing {
                    DatePicker(
                        "Select Date",
                        selection: Binding(
                            get: { task.dueDate ?? Date() },
                            set: { task.dueDate = $0 }
                        ),
                        displayedComponents: .date
                    )
                } else {
                    if let due = task.dueDate {
                        Text(due, style: .date)
                    } else {
                        Text("No due date")
                            .foregroundStyle(.secondary)
                    }
                }
            }
            
            // MARK: Details
            Section("Details") {
                if isEditing {
                    TextField("Enter details", text: Binding(
                        get: { task.details ?? "" },
                        set: { task.details = $0 }
                    ), axis: .vertical)
                } else if let details = task.details, !details.isEmpty {
                    Text(details)
                        .foregroundStyle(.secondary)
                } else {
                    Text("No details")
                        .foregroundStyle(.secondary)
                }
            }
        }
        .navigationTitle("Task Details")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button(isEditing ? "Done" : "Edit") {
                    isEditing.toggle()
                }
            }
        }
    }
    
    private func priorityColor(_ p: Priority) -> Color {
        switch p {
        case .low: return .blue.opacity(0.25)
        case .medium: return .yellow.opacity(0.35)
        case .high: return .red.opacity(0.35)
        }
    }
}

