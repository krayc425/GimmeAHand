//
//  MockDataStore.swift
//  GimmeAHand
//
//  Created by Kuixi Song on 4/19/21.
//

import UIKit
import CoreLocation
import SwiftDate

class MockDataStore: NSObject {

    static let shared: MockDataStore = MockDataStore()
    
    var userList: [UserModel]
    var communityList: [CommunityModel]
    var orderList: [OrderModel]
    
    private override init() {
        userList = [
            UserModel("Kuixi", "Song", "k@s.com", "+14441234567"),
        ]
        communityList = [
            CommunityModel("CMU SV", 37.4104, -122.0598),
            CommunityModel("CMU Pittsburgh", 40.443322, -79.943583),
        ]
        orderList = [
            OrderModel(name: "Printing",
                       description: "Print 10 pages of documents",
                       amount: 3.2,
                       status: .submitted,
                       createDate: Date(),
                       startDate: Date(),
                       endDate: MockDataStore.randomDate(),
                       category: .printing,
                       community: communityList[0],
                       creator: userList.randomElement()!,
                       destination1: CLLocationCoordinate2D(latitude: 37.0, longitude: -120.0)),
        ]
    }
    
    func randomCommunity() -> CommunityModel {
        return communityList.randomElement()!
    }
    
    func randomUser() -> UserModel {
        return userList.randomElement()!
    }
    
    func randomOrder() -> OrderModel {
        return orderList.randomElement()!
    }
    
    private static func randomDate() -> Date {
        return Date()
            + Int.random(in: 0...1).days
            + Int.random(in: 0...23).hours
            + Int.random(in: 1...59).minutes
    }
    
}
