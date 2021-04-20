//
//  DoubleExtensions.swift
//  GimmeAHand
//
//  Created by Kuixi Song on 4/19/21.
//

import Foundation

extension Double {
    
    var distanceString: String {
        let nsNumber = NSNumber(floatLiteral: self)
        return GHConstant.kDistanceFormatter.string(from: nsNumber)!
    }
    
    var amountString: String {
        let nsNumber = NSNumber(floatLiteral: self)
        return GHConstant.kAmountFormatter.string(from: nsNumber)!
    }
    
}
