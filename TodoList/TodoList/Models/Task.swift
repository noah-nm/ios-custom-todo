//
//  Task.swift
//  TodoList
//
//  Created by Noah Mills on 2025-12-26.
//
import Foundation
import SwiftData

enum Priority: String, Codable, CaseIterable {
    case low, medium, high
}

@Model
class Task {
    var name: String
    var details: String?
    var dueDate: Date?
    var priority: Priority = Priority.medium
    var isDone: Bool = false
    var folders: [Folder] = []
    
    init(name: String, details: String? = nil, dueDate: Date? = nil, priority: Priority = .medium, isDone: Bool = false) {
        self.name = name
        self.details = details
        self.dueDate = dueDate
        self.priority = priority
        self.isDone = isDone
    }
    
}
