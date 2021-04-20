//
//  OrderModel.swift
//  GimmeAHand
//
//  Created by Kuixi Song on 3/15/21.
//

import UIKit

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
         creator: UserModel) {
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
    }
    
}
