//
//  OrderHelper.swift
//  GimmeAHand
//
//  Created by Kuixi Song on 4/20/21.
//

import UIKit

class OrderHelper: NSObject {
    
    static let shared: OrderHelper = OrderHelper()
    
    private var orderList: [OrderModel]
    
    private override init() {
        orderList = []
    }
    
    func addOrder(_ order: OrderModel) {
        orderList.append(order)
    }
    
    func takeOrder(_ order: inout OrderModel, _ courier: UserModel) {
        order.status = .inprogress
        order.courier = courier
    }
    
    func cancelOrder(_ order: inout OrderModel) {
        order.status = .cancelled
    }
    
    func finishOrder(_ order: inout OrderModel) {
        order.status = .finished
    }
    
    func getOrderList() -> [OrderModel] {
        return (MockDataStore.shared.orderList + orderList).reversed()
    }

}
