//
//  GHOrderStatus.swift
//  GimmeAHand
//
//  Created by Kuixi Song on 3/18/21.
//

import UIKit

enum GHOrderStatus: String, CaseIterable {
    
    case created
    case inprogress
    case cancelled
    case finished
    
    // TODO: Use what colors...
    func decorate(_ label: inout UILabel) {
        switch self {
        case .created:
            label.text = "Created"
            label.textColor = .systemOrange
        case .inprogress:
            label.text = "In Progress"
            label.textColor = .systemBlue
        case .finished:
            label.text = "Finished"
            label.textColor = .systemGreen
        case .cancelled:
            label.text = "Cancelled"
            label.textColor = .systemRed
        }
    }
    
}
