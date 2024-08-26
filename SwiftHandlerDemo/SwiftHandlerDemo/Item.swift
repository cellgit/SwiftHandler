//
//  Item.swift
//  SwiftHandlerDemo
//
//  Created by admin on 2024/8/26.
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
