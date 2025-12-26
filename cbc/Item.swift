//
//  Item.swift
//  cbc
//
//  Created by Christopher Celayac on 12/25/25.
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
