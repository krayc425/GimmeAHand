//
//  OrderTableViewCell.swift
//  GimmeAHand
//
//  Created by Kuixi Song on 3/15/21.
//

import UIKit

class OrderTableViewCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    
    static let reuseIdentifier: String = "OrderTableViewCell"

    func config(_ model: OrderModel) {
        nameLabel.text = model.name
        descriptionLabel.text = model.orderDescription
        amountLabel.text = String(format: "$%.2f", model.amount)
        statusLabel.text = model.status
    }

}
