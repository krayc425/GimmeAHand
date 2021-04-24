//
//  GHOrderSelectionType.swift
//  GimmeAHand
//
//  Created by Kuixi Song on 4/24/21.
//

import Foundation

enum GHOrderSelectionType: Int, CaseIterable {
    
    case placed = 0
    case taken = 1
    
    var description: String {
        switch self {
        case .placed:
            return "Created by Me"
        case .taken:
            return "Taken by Me"
        }
    }
    
}
