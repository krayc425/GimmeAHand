//
//  GHConstants.swift
//  GimmeAHand
//
//  Created by Kuixi Song on 3/12/21.
//

import UIKit

struct GHConstant {
    
    static let kHUDDuration: TimeInterval = 2.0
    static let kStoryboardTransitionDuration: TimeInterval = 0.5
    
    static let kCornerRadius: CGFloat = 10.0
    static let kDateFormatter: DateFormatter = {
        let fmt = DateFormatter()
        fmt.dateFormat = "MMM dd, yyyy"
        return fmt
    }()
    
}
