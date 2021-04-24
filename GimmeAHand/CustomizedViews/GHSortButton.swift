//
//  GHSortButton.swift
//  GimmeAHand
//
//  Created by Kuixi Song on 4/24/21.
//

import UIKit

class GHSortButton: UIButton {

    var sortMethod: GHOrderSortMethod
    
    init(_ method: GHOrderSortMethod) {
        self.sortMethod = method
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
