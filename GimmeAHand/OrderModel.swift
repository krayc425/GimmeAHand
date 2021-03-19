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
    
    var statusString: String {
        return status.displayString
    }
    var amountString: String {
        return String(format: "$%.2f", amount)
    }
    var createdDateString: String {
        return GHConstant.kDateFormatter.string(from: createdDate)
    }
    
    init(id: Int,
         name: String,
         description: String,
         amount: Float,
         status: GHOrderStatus,
         date: Date) {
        self.id = id
        self.name = name
        self.orderDescription = description
        self.amount = amount
        self.status = status
        self.createdDate = date
    }
    
}
