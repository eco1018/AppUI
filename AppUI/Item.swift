//
//  Item.swift
//  AppUI
//
//  Created by Ella A. Sadduq on 5/31/25.
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
