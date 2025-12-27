//
//  Item.swift
//  TodoList
//
//  Created by Noah Mills on 2025-12-26.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
