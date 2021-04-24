//
//  UserModel.swift
//  GimmeAHand
//
//  Created by Kuixi Song on 4/19/21.
//

import UIKit

class UserModel: NSObject, NSSecureCoding {
    
    static var supportsSecureCoding = true
    
    var firstName: String
    var lastName: String
    var email: String
    var phone: String
    var password: String
    var rating: Double
    
    var takenOrderCount: Int {
        let orders = OrderHelper.shared.getOrderList()
        return orders.filter { $0.courier != nil && $0.courier == self }.count
    }
    var placedOrderCount: Int {
        let orders = OrderHelper.shared.getOrderList()
        return orders.filter { $0.creator == self }.count
    }
    var earnedMoney: Double {
        let orders = OrderHelper.shared.getOrderList()
        let myOrders = orders.filter { $0.courier != nil && $0.courier == self && $0.status == .finished }
        return myOrders.map { $0.amount }.reduce(0, +)
    }
    
    init(_ firstName: String,
         _ lastName: String,
         _ email: String,
         _ phone: String,
         _ password: String,
         _ rating: Double = 0.0) {
        self.firstName = firstName
        self.lastName = lastName
        self.email = email
        self.phone = phone
        self.password = password
        self.rating = rating
    }
    
    convenience override init() {
        self.init("Admin", "Admin", "admin@admin.com", "+1234567890", "admin")
    }
    
    required convenience init(coder aDecoder: NSCoder) {
        let firstName = aDecoder.decodeObject(forKey: "firstName") as! String
        let lastname = aDecoder.decodeObject(forKey: "lastName") as! String
        let email = aDecoder.decodeObject(forKey: "email") as! String
        let phone = aDecoder.decodeObject(forKey: "phone") as! String
        let rating = aDecoder.decodeDouble(forKey: "rating")
        let password = aDecoder.decodeObject(forKey: "password") as! String
        self.init(firstName, lastname, email, phone, password, rating)
    }

    func encode(with aCoder: NSCoder) {
        aCoder.encode(firstName, forKey: "firstName")
        aCoder.encode(lastName, forKey: "lastName")
        aCoder.encode(email, forKey: "email")
        aCoder.encode(phone, forKey: "phone")
        aCoder.encode(rating, forKey: "rating")
        aCoder.encode(password, forKey: "password")
    }
    
    static func ==(_ lhs: UserModel, _ rhs: UserModel) -> Bool {
        return lhs.email == rhs.email
    }

}
