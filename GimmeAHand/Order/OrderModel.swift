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
    var category: GHOrderCategory
    var community: String

    var amountString: String {
        return GHConstant.kAmountFormatter.string(from: NSNumber(floatLiteral: Double(amount)))!
    }
    var createdDateString: String {
        return GHConstant.kDateFormatter.string(from: createdDate)
    }
    
    var isTaken: Bool {
        return status == .inprogress || status == .finished
    }
    
    init(id: Int,
         name: String,
         description: String,
         amount: Float,
         status: GHOrderStatus,
         date: Date,
         category: GHOrderCategory,
         community: String) {
        self.id = id
        self.name = name
        self.orderDescription = description
        self.amount = amount
        self.status = status
        self.createdDate = date
        self.category = category
        self.community = community
    }
    
}
