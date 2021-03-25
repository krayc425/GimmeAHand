//
//  CategorySelectionTableViewCell.swift
//  GimmeAHand
//
//  Created by Kuixi Song on 3/24/21.
//

import UIKit

class CategorySelectionTableViewCell: UITableViewCell {
    
    static let reuseIdentifier = "categorySelectionTableViewCellId"
    
    @IBOutlet weak var categoryImageView: UIImageView!
    @IBOutlet weak var categoryLabel: UILabel!
    
    func config(_ category: GHOrderCategory) {
        categoryLabel.text = category.rawValue
        category.fill(in: &categoryImageView)
    }
    
}
