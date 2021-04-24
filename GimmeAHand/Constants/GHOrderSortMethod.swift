//
//  GHOrderSortMethod.swift
//  GimmeAHand
//
//  Created by Kuixi Song on 4/24/21.
//

import Foundation
import CoreLocation
import SwiftDate

enum GHOrderSortMethod: Equatable {

    case latest
    case expireSoon
    case highestTips
    case nearest(CLLocation)
    
    var handler: ((OrderModel, OrderModel) -> Bool) {
        switch self {
        case .latest:
            return { model1, model2 in
                return model1.createDate > model2.createDate
            }
        case .expireSoon:
            return { model1, model2 in
                return model1.endDate < model2.endDate
            }
        case .highestTips:
            return { model1, model2 in
                return model1.amount > model2.amount
            }
        case .nearest(let location):
            return { model1, model2 in
                return model1.destinationDistanceFromLocation(location) < model2.destinationDistanceFromLocation(location)
            }
        }
    }
    
    var tag: Int {
        switch self {
        case .latest:
            return 0
        case .expireSoon:
            return 1
        case .highestTips:
            return 2
        case .nearest(_):
            return 3
        }
    }
    
    var description: String {
        switch self {
        case .latest:
            return "Newly Created"
        case .expireSoon:
            return "Expire Soon"
        case .highestTips:
            return "Highest Tips"
        case .nearest(_):
            return "Nearest To You"
        }
    }
    
    static func ==(_ lhs: GHOrderSortMethod, _ rhs: GHOrderSortMethod) -> Bool {
        switch (lhs, rhs) {
        case (.latest, .latest):
            return true
        case (.expireSoon, .expireSoon):
            return true
        case (.highestTips, .highestTips):
            return true
        case (.nearest(_), .nearest(_)):
            return true
        default:
            return false
        }
    }
    
}
