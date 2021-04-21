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
        currentUser = UserModel()
        userList = []
    }
    
    func getUserList() -> [UserModel] {
        return MockDataStore.shared.userList + userList
    }
    
    func findUser(_ email: String, _ password: String) -> UserModel? {
        return getUserList().filter { $0.email == email }.first
    }
    
    func addUser(_ user: UserModel) {
        userList.append(user)
        saveUserList()
    }
    
    private func saveUserList() {
        userDefaultsHelper.saveUserList(userList)
    }
    
}
