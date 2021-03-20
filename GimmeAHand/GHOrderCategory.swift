//
//  GHOrderCategory.swift
//  GimmeAHand
//
//  Created by Kuixi Song on 3/18/21.
//

import UIKit

enum GHOrderCategory: String, CaseIterable {
    
    // TODO: can add more categories
    case printing = "Printing"
    case carpool = "Car Pool"
    case supermarket = "Supermarket"
    case shipping = "Shipping"
    case umbrella = "Umbrella"
    case takeout = "Takeout"
    
    func fill(in imageView: inout UIImageView) {
        switch self {
        case .printing:
            imageView.image = UIImage(systemName: "printer.fill")
        case .carpool:
            imageView.image = UIImage(systemName: "car.2.fill")
        case .supermarket:
            imageView.image = UIImage(systemName: "cart.fill")
        case .shipping:
            imageView.image = UIImage(systemName: "shippingbox.fill")
        case .umbrella:
            imageView.image = UIImage(systemName: "umbrella.fill")
        case .takeout:
            imageView.image = UIImage(systemName: "mouth.fill")
        }
        imageView.tintColor = .link
    }
    
}
