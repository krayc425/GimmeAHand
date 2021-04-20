//
//  GHOrderCategory.swift
//  GimmeAHand
//
//  Created by Kuixi Song on 3/18/21.
//

import UIKit

enum GHOrderCategory: String, CaseIterable {
    
    case printing = "Printing"
    case carpool = "Car Pool"
    case supermarket = "Shopping"
    case shipping = "Shipping"
    case umbrella = "Umbrella"
    case takeout = "Takeout"
    
    func fill(in imageView: inout UIImageView) {
        imageView.image = getImage()
    }
    
    func getImage() -> UIImage? {
        switch self {
        case .printing:
            return UIImage(systemName: "printer.fill")
        case .carpool:
            return UIImage(systemName: "car.2.fill")
        case .supermarket:
            return UIImage(systemName: "cart.fill")
        case .shipping:
            return UIImage(systemName: "shippingbox.fill")
        case .umbrella:
            return UIImage(systemName: "umbrella.fill")
        case .takeout:
            return UIImage(named: "takeout")
        }
    }
    
    func getDestinations() -> [String] {
        switch self {
        case .printing:
            return ["Choose Destination"]
        case .carpool:
            return ["Choose Destination"]
        case .supermarket:
            return ["Choose Market Location", "Choose Destination"]
        case .shipping:
            return ["Choose Pickup Location"]
        case .umbrella:
            return ["Choose Destination"]
        case .takeout:
            return ["Choose Restaurant Location", "Choose Destination"]
        }
    }
    
}
