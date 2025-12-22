//
//  Item.swift
//  E-Cycle Finder
//
//  Created by Jayden Li on 2025-12-22.
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
