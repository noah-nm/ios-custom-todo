//
//  Task.swift
//  TodoList
//
//  Created by Noah Mills on 2025-12-26.
//
import Foundation
import SwiftData

enum Priority: String, Codable {
    case low
    case medium
    case high
}

@Model
class Task {
    var title: String
    var details: String?
    var dueDate: Date?
    var priority: Priority = Priority.medium
    var isDone: Bool = false
    var folders: [Folder] = []
    
    init(title: String, details: String? = nil, dueDate: Date? = nil, priority: Priority = .medium, isDone: Bool = false) {
        self.title = title
        self.details = details
        self.dueDate = dueDate
        self.priority = priority
        self.isDone = isDone
    }
    
}
