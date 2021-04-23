//
//  OrderHelper.swift
//  GimmeAHand
//
//  Created by Kuixi Song on 4/20/21.
//

import UIKit

class OrderHelper: NSObject {
    
    static let shared: OrderHelper = OrderHelper()
    private let userDefaultsHelper = UserDefaultsHelper.shared
    
    private var orderList: [OrderModel]
    
    private override init() {
        orderList = []
    }
    
    func addOrder(_ order: OrderModel) {
        orderList.append(order)
        saveOrderList()
    }
    
    func takeOrder(_ order: inout OrderModel, _ courier: UserModel) {
        order.status = .inprogress
        order.courier = courier
        saveOrderList()
    }
    
    func cancelOrder(_ order: inout OrderModel) {
        order.status = .cancelled
        saveOrderList()
    }
    
    func finishOrder(_ order: inout OrderModel) {
        order.status = .finished
        saveOrderList()
    }
    
    func saveOrderList() {
        userDefaultsHelper.saveOrderList(orderList)
    }
    
    func getOrderList() -> [OrderModel] {
        orderList = userDefaultsHelper.getOrderList()
        return (MockDataStore.shared.orderList + orderList).reversed()
    }

}
