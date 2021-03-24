//
//  PaymentTableViewCell.swift
//  GimmeAHand
//
//  Created by Kuixi Song on 3/23/21.
//

import UIKit

class PaymentTableViewCell: UITableViewCell {
    
    static let reuseIdentifier = "paymentTableViewCellId"
    
    @IBOutlet weak var paymentLabel: UILabel!
    @IBOutlet weak var paymentImageView: UIImageView!

    func config(_ payment: GHPaymentType) {
        paymentLabel.text = payment.rawValue
    }
    
}
