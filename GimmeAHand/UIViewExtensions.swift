//
//  UIViewExtensions.swift
//  GimmeAHand
//
//  Created by Kuixi Song on 3/20/21.
//

import UIKit

extension UIView {
    
    func setRoundCorner() {
        self.layer.cornerRadius = GHConstant.kCornerRadius
        self.layer.masksToBounds = true
    }
    
}
