//
//  Item.swift
//  CekFakta
//
//  Created by Heical Chandra on 24/11/25.
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
