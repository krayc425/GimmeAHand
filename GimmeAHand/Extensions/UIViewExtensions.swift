//
//  UIViewExtensions.swift
//  GimmeAHand
//
//  Created by Kuixi Song on 3/20/21.
//

import UIKit

extension UIView {
    
    func setRoundCorner(_ cornerRadius: CGFloat = GHConstant.kCornerRadius) {
        layer.cornerRadius = cornerRadius
        layer.masksToBounds = true
    }
    
}
