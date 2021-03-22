//
//  GHStatusLabel.swift
//  GimmeAHand
//
//  Created by Kuixi Song on 3/21/21.
//

import UIKit

class GHStatusLabel: UILabel {
    
    static let font = UIFont.boldSystemFont(ofSize: UIFont.systemFontSize)
    static let cornerRadius: CGFloat = 7.5
    static let contentInsets = UIEdgeInsets(top: 2.0, left: 10.0, bottom: 2.0, right: 10.0)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        font = GHStatusLabel.font
        textColor = .white
        setRoundCorner(GHStatusLabel.cornerRadius)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        font = GHStatusLabel.font
        textColor = .white
        setRoundCorner(GHStatusLabel.cornerRadius)
    }

    override func drawText(in rect: CGRect) {
        let insetRect = rect.inset(by: GHStatusLabel.contentInsets)
        super.drawText(in: insetRect)
    }

    override var intrinsicContentSize: CGSize {
        return addInsets(to: super.intrinsicContentSize)
    }

    override func sizeThatFits(_ size: CGSize) -> CGSize {
        return addInsets(to: super.sizeThatFits(size))
    }

    private func addInsets(to size: CGSize) -> CGSize {
        let width = size.width + GHStatusLabel.contentInsets.left + GHStatusLabel.contentInsets.right
        let height = size.height + GHStatusLabel.contentInsets.top + GHStatusLabel.contentInsets.bottom
        return CGSize(width: width, height: height)
    }
    
}
