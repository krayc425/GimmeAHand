//
//  OrderTableViewCell.swift
//  GimmeAHand
//
//  Created by Kuixi Song on 3/15/21.
//

import UIKit
import CoreLocation

class OrderTableViewCell: UITableViewCell {
    
    static let reuseIdentifier: String = "orderTableViewCellId"
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var categoryImageView: UIImageView!
    @IBOutlet weak var statusLabel: GHStatusLabel!
    @IBOutlet weak var communityLabel: UILabel!

    func config(_ model: OrderModel, _ currentLocation: CLLocation? = nil) {
        nameLabel.text = model.name
        if let location = currentLocation {
            // From homepage
            statusLabel.isHidden = true
            dateLabel.text = "\(model.expireDateString)\n\(model.destinationDistanceFromLocation(location).distanceString) from you"
        } else {
            // From order history
            statusLabel.isHidden = false
            dateLabel.text = model.createDateString
        }
        amountLabel.text = model.amountString
        model.status.decorate(&statusLabel)
        communityLabel.text = model.community.name
        model.category.fill(in: &categoryImageView)
    }

}
