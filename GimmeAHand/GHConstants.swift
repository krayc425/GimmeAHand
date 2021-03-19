//
//  GHConstants.swift
//  GimmeAHand
//
//  Created by Kuixi Song on 3/12/21.
//

import Foundation

struct GHConstant {
    
    static let kHUDDuration: TimeInterval = 2.0
    static let kDateFormatter: DateFormatter = {
        let fmt = DateFormatter()
        fmt.dateFormat = "MMM dd, yyyy"
        return fmt
    }()
    
}