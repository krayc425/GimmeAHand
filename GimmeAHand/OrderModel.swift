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
    var status: String
    
    init(_ id: Int,
         _ name: String,
         _ description: String,
         _ amount: Float,
         _ status: String) {
        self.id = id
        self.name = name
        self.orderDescription = description
        self.amount = amount
        self.status = status
    }
    
}
