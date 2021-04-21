//
//  OrderModel.swift
//  GimmeAHand
//
//  Created by Kuixi Song on 3/15/21.
//

import UIKit
import CoreLocation

class OrderModel: NSObject {
    
    var name: String
    var orderDescription: String
    var amount: Double
    var status: GHOrderStatus
    var createdDate: Date
    var startDate: Date
    var endDate: Date
    var category: GHOrderCategory
    var community: CommunityModel
    var creator: UserModel
    var courier: UserModel?
    var destination1: CLLocationCoordinate2D
    var destination2: CLLocationCoordinate2D?

    var amountString: String {
        return amount.amountString
    }
    var validDateString: String {
        return GHConstant.kOrderDateFormatter.string(from: endDate)
    }
    var expireDateString: String {
        return "Expire on \(GHConstant.kOrderDateFormatter.string(from: endDate))"
    }
    
    var isInProgress: Bool {
        return status == .inprogress
    }
    
    var shouldDisplayCourier: Bool {
        return status == .inprogress || status == .finished
    }
    
    init(name: String,
         description: String,
         amount: Double,
         status: GHOrderStatus,
         createDate: Date,
         startDate: Date,
         endDate: Date,
         category: GHOrderCategory,
         community: CommunityModel,
         creator: UserModel,
         courier: UserModel? = nil,
         destination1: CLLocationCoordinate2D,
         destination2: CLLocationCoordinate2D? = nil) {
        self.name = name
        self.orderDescription = description
        self.amount = amount
        self.status = status
        self.createdDate = createDate
        self.startDate = startDate
        self.endDate = endDate
        self.category = category
        self.community = community
        self.creator = creator
        self.courier = courier
        self.destination1 = destination1
        self.destination2 = destination2
    }
    
    convenience override init() {
        self.init(name: "",
                  description: "",
                  amount: 0.0,
                  status: .submitted,
                  createDate: Date(),
                  startDate: Date(),
                  endDate: Date(),
                  category: .carpool,
                  community: CommunityModel(),
                  creator: UserModel(),
                  courier: nil,
                  destination1: CLLocationCoordinate2D(),
                  destination2: nil)
    }
    
}
