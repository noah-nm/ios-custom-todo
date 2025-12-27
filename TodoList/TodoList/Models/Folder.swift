//
//  Folder.swift
//  TodoList
//
//  Created by Noah Mills on 2025-12-26.
//

import Foundation
import SwiftData

@Model
class Folder {
    var name: String
    var details: String?
    var parent: Folder?
    var children: [Folder] = []
    var tasks: [Task] = []
    
    init(name: String, details: String? = nil) {
        self.name = name
        self.details = details
    }
}
