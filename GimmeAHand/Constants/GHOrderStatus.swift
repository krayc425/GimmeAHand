//
//  GHOrderStatus.swift
//  GimmeAHand
//
//  Created by Kuixi Song on 3/18/21.
//

import UIKit

enum GHOrderStatus: String, CaseIterable {
    
    case submitted = "Submitted"
    case inprogress = "In Progress"
    case cancelled = "Cancelled"
    case finished = "Finished"
    
    func decorate(_ label: inout GHStatusLabel) {
        label.text = rawValue
        label.backgroundColor = color
        label.setRoundCorner(7.5)
    }
    
    var color: UIColor? {
        return UIColor(named: rawValue)
    }
    
    var description: String {
        switch self {
        case .submitted:
            return "hasn't been taken by a courier."
        case .inprogress:
            return "has been taken by a courier."
        case .cancelled:
            return "is cancelled."
        case .finished:
            return "has been fulfilled by a courier."
        }
    }
    
}
