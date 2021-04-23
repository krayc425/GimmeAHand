//
//  UserDefaultsHelper.swift
//  GimmeAHand
//
//  Created by Kuixi Song on 3/28/21.
//

import UIKit

class UserDefaultsHelper: NSObject {

    static let shared: UserDefaultsHelper = UserDefaultsHelper()
    
    private let defaults: UserDefaults
    
    private override init() {
        defaults = UserDefaults.standard
    }
    
    func saveFaceID(_ using: Bool) {
        defaults.set(using, forKey: "gh_use_faceid")
        defaults.synchronize()
    }
    
    func getFaceID() -> Bool {
        return defaults.bool(forKey: "gh_use_faceid")
    }
    
    func saveRememberMe(_ remember: Bool) {
        defaults.set(remember, forKey: "gh_remember_me")
        defaults.synchronize()
    }
    
    func getRememberMe() -> Bool {
        return defaults.bool(forKey: "gh_remember_me")
    }
    
    func saveEmail(_ email: String) {
        defaults.set(email, forKey: "gh_email")
        defaults.synchronize()
    }
    
    func getEmail() -> String? {
        return defaults.string(forKey: "gh_email")
    }
    
    func saveUserList(_ users: [UserModel]) {
        let encodedData: Data = try! NSKeyedArchiver.archivedData(withRootObject: users, requiringSecureCoding: true)
        defaults.set(encodedData, forKey: "user_list")
        defaults.synchronize()
    }
    
    func getUserList() -> [UserModel] {
        let decodedData = defaults.data(forKey: "user_list")
        if let data = decodedData {
            return try! NSKeyedUnarchiver.unarchivedArrayOfObjects(ofClasses: [UserModel.self], from: data) as! [UserModel]
        } else {
            return []
        }
    }
    
    func saveOrderList(_ orders: [OrderModel]) {
        let encodedData: Data = try! NSKeyedArchiver.archivedData(withRootObject: orders, requiringSecureCoding: true)
        defaults.set(encodedData, forKey: "order_list5")
        defaults.synchronize()
    }
    
    func getOrderList() -> [OrderModel] {
        let decodedData = defaults.data(forKey: "order_list5")
        if let data = decodedData {
            return try! NSKeyedUnarchiver.unarchivedArrayOfObjects(ofClasses: [OrderModel.self], from: data) as! [OrderModel]
        } else {
            return []
        }
    }
    
}
