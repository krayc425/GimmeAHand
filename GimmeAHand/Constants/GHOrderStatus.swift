//
//  GHOrderStatus.swift
//  GimmeAHand
//
//  Created by Kuixi Song on 3/18/21.
//

import UIKit

enum GHOrderStatus: String, CaseIterable {
    
    case created = "Created"
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
        label.setRoundCorner()
    }
    
    var description: String {
        switch self {
        case .created:
            return "The order hasn't been taken by a courier."
        case .inprogress:
            return "The order has been taken by a courier."
        case .cancelled:
            return "The order is cancelled."
        case .finished:
            return "The order has been fulfilled by a courier."
        }
    }
    
}
