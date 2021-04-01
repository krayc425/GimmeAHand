//
//  GHConstants.swift
//  GimmeAHand
//
//  Created by Kuixi Song on 3/12/21.
//

import UIKit

struct GHConstant {
    
    /// Durations
    
    static let kHUDDuration: TimeInterval = 2.0
    static let kFilterViewTransitionDuration: TimeInterval = 0.2
    static let kStoryboardTransitionDuration: TimeInterval = 0.5
    
    /// UI
    
    static let kCornerRadius: CGFloat = 10.0
    
    /// Formatters
    
    static let kDateFormatter: DateFormatter = {
        let fmt = DateFormatter()
        fmt.dateFormat = "MMM dd, yyyy"
        return fmt
    }()
    static let kAmountFormatter: NumberFormatter = {
        let currencyFormatter = NumberFormatter()
        currencyFormatter.numberStyle = .currency
        currencyFormatter.currencySymbol = "$"
        currencyFormatter.minimumIntegerDigits = 1
        currencyFormatter.maximumFractionDigits = 2
        return currencyFormatter
    }()
    static let kDistanceFormatter: NumberFormatter = {
        let currencyFormatter = NumberFormatter()
        currencyFormatter.numberStyle = .decimal
        currencyFormatter.positiveSuffix = " mi"
        currencyFormatter.minimumIntegerDigits = 1
        currencyFormatter.maximumFractionDigits = 1
        return currencyFormatter
    }()
    
}
