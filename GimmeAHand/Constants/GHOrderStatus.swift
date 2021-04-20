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
    
    func decorate(_ label: inout GHStatusLabel, withDescription: Bool = false) {
        if withDescription {
            label.text = "\(rawValue): \(description)"
        } else {
            label.text = rawValue
        }
        label.backgroundColor = UIColor(named: rawValue)
        label.setRoundCorner(7.5)
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
