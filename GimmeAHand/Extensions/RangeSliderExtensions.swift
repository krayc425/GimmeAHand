//
//  RangeSliderExtensions.swift
//  GimmeAHand
//
//  Created by Kuixi Song on 3/20/21.
//

import RangeSeekSlider

enum RangeSliderTag: Int {
    
    case amount
    case distance
    
}

extension RangeSeekSlider {
    
    func setupGHStyle() {
        minLabelFont = UIFont.preferredFont(forTextStyle: .body)
        maxLabelFont = UIFont.preferredFont(forTextStyle: .body)
        tintColor = .lightGray
        handleColor = .GHTint
        minLabelColor = .GHTint
        maxLabelColor = .GHTint
        colorBetweenHandles = .GHTint
    }
    
}
