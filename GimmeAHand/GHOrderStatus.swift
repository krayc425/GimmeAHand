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
    
    // TODO: Use what colors...
    func decorate(_ label: inout UILabel) {
        label.text = self.rawValue
        switch self {
        case .created:
            label.textColor = .systemOrange
        case .inprogress:
            label.textColor = .systemBlue
        case .finished:
            label.textColor = .systemGreen
        case .cancelled:
            label.textColor = .systemRed
        }
    }
    
}
