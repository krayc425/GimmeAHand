//
//  GHOrderStatus.swift
//  GimmeAHand
//
//  Created by Kuixi Song on 3/18/21.
//

enum GHOrderStatus: String {
    
    case created
    case inprogress
    case cancelled
    case finished
    
    var displayString: String {
        switch self {
        case .created:
            return "Created"
        case .inprogress:
            return "In Progress"
        case .finished:
            return "Finished"
        case .cancelled:
            return "Cancelled"
        }
    }
    
}
