//
//  GHCommunitySearchType.swift
//  GimmeAHand
//
//  Created by Kuixi Song on 4/24/21.
//

import Foundation

enum GHCommunitySearchType {
    
    case none
    case add
    case filter
    case select
    
    var title: String {
        switch self {
        case .add:
            return "Add a Community"
        case .filter:
            return "Filter by Community"
        case .select:
            return "Select a Community"
        case .none:
            return ""
        }
    }
    
    var description: String? {
        switch self {
        case .add:
            return "We only display available communities within 3 miles of your current location."
        case .filter:
            return "Your communities"
        case .select, .none:
            return nil
        }
    }
    
}
