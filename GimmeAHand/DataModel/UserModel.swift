//
//  UserModel.swift
//  GimmeAHand
//
//  Created by Kuixi Song on 4/19/21.
//

import UIKit

class UserModel: NSObject {
    
    var firstName: String
    var lastName: String
    var email: String
    var phone: String
    var rating: Double
    
    init(_ firstName: String,
         _ lastName: String,
         _ email: String,
         _ phone: String) {
        self.firstName = firstName
        self.lastName = lastName
        self.email = email
        self.phone = phone
        self.rating = 0.0
    }

}
