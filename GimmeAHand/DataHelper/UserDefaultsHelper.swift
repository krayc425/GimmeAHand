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
    
}
