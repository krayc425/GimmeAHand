//
//  UserHelper.swift
//  GimmeAHand
//
//  Created by Kuixi Song on 4/20/21.
//

import Foundation

class UserHelper: NSObject {
    
    static let shared: UserHelper = UserHelper()
    private let userDefaultsHelper = UserDefaultsHelper.shared
    
    private var userList: [UserModel]
    var currentUser: UserModel
    
    private override init() {
        currentUser = userDefaultsHelper.getCurrentUser() ?? UserModel()
        userList = []
    }
    
    func getUserList() -> [UserModel] {
        return MockDataStore.shared.userList + userList
    }
    
    func findUser(_ email: String, _ password: String) -> UserModel? {
        return getUserList().filter {
            $0.email == email && $0.password == password
        }.first
    }
    
    func addUser(_ user: UserModel) {
        userList.append(user)
        saveUserList()
    }
    
    private func saveUserList() {
        userDefaultsHelper.saveUserList(userList)
    }
    
    func loginUser(_ email: String, _ password: String) -> Bool {
        guard let user = findUser(email, password) else {
            return false
        }
        userDefaultsHelper.saveCurrentUser(user)
        currentUser = user
        return true
    }
    
    func logout() {
        userDefaultsHelper.clearCurrentUser()
    }
    
}
