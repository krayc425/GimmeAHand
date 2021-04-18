//
//  OrderModel.swift
//  GimmeAHand
//
//  Created by Kuixi Song on 3/15/21.
//

import UIKit

class OrderModel: NSObject {
    
    var id: Int
    var name: String
    var orderDescription: String
    var amount: Float
    var status: GHOrderStatus
    var createdDate: Date
    var startDate: Date
    var endDate: Date
    var category: GHOrderCategory
    var community: String

    var amountString: String {
        return GHConstant.kAmountFormatter.string(from: NSNumber(floatLiteral: Double(amount)))!
    }
    var validDateString: String {
        return GHConstant.kOrderDateFormatter.string(from: endDate)
    }
    var expireDateString: String {
        return "Expire on \(GHConstant.kOrderDateFormatter.string(from: endDate))"
    }
    
    var isTaken: Bool {
        return status == .inprogress || status == .finished
    }
    
    init(id: Int,
         name: String,
         description: String,
         amount: Float,
         status: GHOrderStatus,
         createDate: Date,
         startDate: Date,
         endDate: Date,
         category: GHOrderCategory,
         community: String) {
        self.id = id
        self.name = name
        self.orderDescription = description
        self.amount = amount
        self.status = status
        self.createdDate = createDate
        self.startDate = startDate
        self.endDate = endDate
        self.category = category
        self.community = community
    }
    
}
