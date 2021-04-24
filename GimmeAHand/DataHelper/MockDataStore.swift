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
            UserModel("Kuixi", "Song", "k@s.com", "+14441234567", "admin"),
            UserModel("Nathan", "Lu", "n@l.com", "+14126794835", "admin"),
            UserModel("Lily", "Yan", "l@y.com", "+14367464978", "admin"),
            UserModel("Jess", "Duncan", "j@d.com", "+13985670273", "admin"),
            UserModel("Helena", "Williams", "h@w.com", "+13879253099", "admin"),
        ]
        communityList = [
            CommunityModel("CMU SV", 37.4104, -122.0598),
            CommunityModel("CMU Pittsburgh", 40.443322, -79.943583),
            CommunityModel("Oak Hill Apartments", 40.4428, -79.9707),
            CommunityModel("Amberson Plaza", 40.4539, -79.9430),
            CommunityModel("Coda On Centre", 40.4579, -79.9323),
            CommunityModel("Kenmawr Apartments", 40.4552, -79.9211),
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
            OrderModel(name: "Takeout",
                       description: "Buy a Sweet and Sour chicken for lunch",
                       amount: 4,
                       status: .submitted,
                       createDate: Date(),
                       startDate: Date(),
                       endDate: MockDataStore.randomDate(),
                       category: .takeout,
                       community: communityList[2],
                       creator: userList.randomElement()!,
                       destination1: CLLocationCoordinate2D(latitude: 37.0, longitude: -120.0)),
            OrderModel(name: "Shipping",
                       description: "Ship my package",
                       amount: 4.5,
                       status: .submitted,
                       createDate: Date(),
                       startDate: Date(),
                       endDate: MockDataStore.randomDate(),
                       category: .shipping,
                       community: communityList[3],
                       creator: userList.randomElement()!,
                       destination1: CLLocationCoordinate2D(latitude: 37.0, longitude: -120.0)),
            OrderModel(name: "Shopping",
                       description: "Buy a tuna sandwich from the supermarket",
                       amount: 3,
                       status: .submitted,
                       createDate: Date(),
                       startDate: Date(),
                       endDate: MockDataStore.randomDate(),
                       category: .supermarket,
                       community: communityList[1],
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
