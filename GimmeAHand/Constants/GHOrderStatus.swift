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
    
    func decorate(_ label: inout GHStatusLabel) {
        label.text = rawValue
        label.backgroundColor = UIColor(named: rawValue)
    }
    
}
