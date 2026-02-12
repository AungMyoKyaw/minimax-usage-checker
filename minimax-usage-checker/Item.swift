//
//  Item.swift
//  minimax-usage-checker
//
//  Created by Aung Myo Kyaw on 2/13/26.
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
