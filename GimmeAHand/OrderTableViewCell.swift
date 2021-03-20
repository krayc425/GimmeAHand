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
    @IBOutlet weak var statusLabel: UILabel!

    func config(_ model: OrderModel) {
        nameLabel.text = model.name
        dateLabel.text = model.createdDateString
        amountLabel.text = model.amountString
        model.status.decorate(&statusLabel)
        model.category.fill(in: &categoryImageView)
    }

}
