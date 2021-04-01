//
//  OrderTableViewCell.swift
//  GimmeAHand
//
//  Created by Kuixi Song on 3/15/21.
//

import UIKit

class OrderTableViewCell: UITableViewCell {
    
    static let reuseIdentifier: String = "orderTableViewCellId"
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var categoryImageView: UIImageView!
    @IBOutlet weak var statusLabel: GHStatusLabel!
    @IBOutlet weak var communityLabel: UILabel!

    func config(_ model: OrderModel, _ hideStatus: Bool) {
        nameLabel.text = model.name
        dateLabel.isHidden = !hideStatus
        dateLabel.text = "\(model.expireDateString)\n0.5 miles from you"
        amountLabel.text = model.amountString
        statusLabel.isHidden = hideStatus
        if !hideStatus {
            model.status.decorate(&statusLabel)
        }
        communityLabel.text = model.community
        model.category.fill(in: &categoryImageView)
    }

}
