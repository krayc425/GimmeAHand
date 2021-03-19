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
         date: Date,
         category: GHOrderCategory) {
        self.id = id
        self.name = name
        self.orderDescription = description
        self.amount = amount
        self.status = status
        self.createdDate = date
        self.category = category
    }
    
}
