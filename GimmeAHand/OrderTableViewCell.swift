//
//  OrderTableViewCell.swift
//  GimmeAHand
//
//  Created by Kuixi Song on 3/15/21.
//

import UIKit

class OrderTableViewCell: UITableViewCell {
    
    static let reuseIdentifier: String = "OrderTableViewCell"
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!

    func config(_ model: OrderModel) {
        nameLabel.text = model.name
        dateLabel.text = model.createdDateString
        amountLabel.text = model.amountString
        statusLabel.text = model.statusString
    }

}
