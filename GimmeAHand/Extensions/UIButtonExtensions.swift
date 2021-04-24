//
//  UIButtonExtensions.swift
//  GimmeAHand
//
//  Created by Kuixi Song on 4/24/21.
//

import UIKit

extension UIButton {
    
    func updateSelectionColor(selected: Bool) {
        if selected {
            backgroundColor = .GHTint
            setTitleColor(.white, for: .normal)
            tintColor = .white
        } else {
            backgroundColor = .systemBackground
            setTitleColor(.GHTint, for: .normal)
            tintColor = .GHTint
        }
    }
    
}
