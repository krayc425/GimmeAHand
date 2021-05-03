//
//  OrderModel.swift
//  GimmeAHand
//
//  Created by Kuixi Song on 3/15/21.
//

import UIKit
import CoreLocation

class OrderModel: NSObject, NSSecureCoding {
    
    static var supportsSecureCoding = true
    let randomized = (Double.random(in: -1...1) / 1000.0, Double.random(in: -1...1) / 1000.0)
    
    var name: String
    var orderDescription: String
    var amount: Double
    var status: GHOrderStatus
    var createDate: Date
    var startDate: Date
    var endDate: Date
    var category: GHOrderCategory
    var community: CommunityModel
    var creator: UserModel
    var courier: UserModel?
    var destination1: CLLocationCoordinate2D
    var destination2: CLLocationCoordinate2D?

    var amountString: String {
        return amount.amountString
    }
    var validDateString: String {
        return GHConstant.kExpireDateFormatter.string(from: endDate)
    }
    var createDateString: String {
        return "Created on \(GHConstant.kCreateDateFormatter.string(from: createDate))"
    }
    var expireDateString: String {
        return "Expire on \(validDateString)"
    }
    var randomizedDestination1: CLLocationCoordinate2D {
        if status == .submitted {
            return CLLocationCoordinate2D(latitude: destination1.latitude + randomized.0,
                                          longitude: destination1.longitude + randomized.1)
        } else {
            return destination1
        }
    }
    var randomizedDestination2: CLLocationCoordinate2D? {
        if let destination2 = destination2 {
            if status == .submitted {
                return CLLocationCoordinate2D(latitude: destination2.latitude + randomized.0,
                                              longitude: destination2.longitude + randomized.1)
            } else {
                return destination2
            }
        } else {
            return nil
        }
    }
    
    override var debugDescription: String {
        return "\(name), \(community.name), \(expireDateString)"
    }
    
    init(name: String,
         description: String,
         amount: Double,
         status: GHOrderStatus,
         createDate: Date,
         startDate: Date,
         endDate: Date,
         category: GHOrderCategory,
         community: CommunityModel,
         creator: UserModel,
         courier: UserModel? = nil,
         destination1: CLLocationCoordinate2D,
         destination2: CLLocationCoordinate2D? = nil) {
        self.name = name
        self.orderDescription = description
        self.amount = amount
        self.status = status
        self.createDate = createDate
        self.startDate = startDate
        self.endDate = endDate
        self.category = category
        self.community = community
        self.creator = creator
        self.courier = courier
        self.destination1 = destination1
        self.destination2 = destination2
    }
    
    convenience override init() {
        self.init(name: "",
                  description: "",
                  amount: 0.0,
                  status: .submitted,
                  createDate: Date(),
                  startDate: Date(),
                  endDate: Date(),
                  category: .carpool,
                  community: CommunityModel(),
                  creator: UserModel(),
                  courier: nil,
                  destination1: CLLocationCoordinate2D(),
                  destination2: nil)
    }
    
    required convenience init(coder aDecoder: NSCoder) {
        let name = aDecoder.decodeObject(forKey: "name") as! String
        let orderDescription = aDecoder.decodeObject(forKey: "orderDescription") as! String
        let amount = aDecoder.decodeDouble(forKey: "amount")
        let status = GHOrderStatus(rawValue: aDecoder.decodeObject(forKey: "status") as! String)!
        let createDate = aDecoder.decodeObject(of: NSDate.self, forKey: "createDate")! as Date
        let startDate = aDecoder.decodeObject(of: NSDate.self, forKey: "startDate")! as Date
        let endDate = aDecoder.decodeObject(of: NSDate.self, forKey: "endDate")! as Date
        let category = GHOrderCategory(rawValue: aDecoder.decodeObject(forKey: "category") as! String)!
        let community = aDecoder.decodeObject(of: CommunityModel.self, forKey: "community")!
        let creator = aDecoder.decodeObject(of: UserModel.self, forKey: "creator")!
        var courier: UserModel? = nil
        if aDecoder.containsValue(forKey: "courier") {
            courier = aDecoder.decodeObject(of: UserModel.self, forKey: "courier")
        }
        let destination1_lat = aDecoder.decodeDouble(forKey: "destination1_lat")
        let destination1_long = aDecoder.decodeDouble(forKey: "destination1_long")
        var destionation2: CLLocationCoordinate2D? = nil
        if aDecoder.containsValue(forKey: "destination2_lat")
            && aDecoder.containsValue(forKey: "destination2_long") {
            destionation2 = CLLocationCoordinate2D(latitude: aDecoder.decodeDouble(forKey: "destination2_lat"), longitude: aDecoder.decodeDouble(forKey: "destination2_long"))
        }
        self.init(
            name: name,
            description: orderDescription,
            amount: amount,
            status: status,
            createDate: createDate,
            startDate: startDate,
            endDate: endDate,
            category: category,
            community: community,
            creator: creator,
            courier: courier,
            destination1: CLLocationCoordinate2D(latitude: destination1_lat,
                                                 longitude: destination1_long),
            destination2: destionation2
        )
    }

    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: "name")
        aCoder.encode(orderDescription, forKey: "orderDescription")
        aCoder.encode(amount, forKey: "amount")
        aCoder.encode(status.rawValue, forKey: "status")
        aCoder.encode(createDate, forKey: "createDate")
        aCoder.encode(startDate, forKey: "startDate")
        aCoder.encode(endDate, forKey: "endDate")
        aCoder.encode(category.rawValue, forKey: "category")
        aCoder.encode(community, forKey: "community")
        aCoder.encode(creator, forKey: "creator")
        if let courier = courier {
            aCoder.encode(courier, forKey: "courier")
        }
        aCoder.encode(destination1.latitude, forKey: "destination1_lat")
        aCoder.encode(destination1.longitude, forKey: "destination1_long")
        if let destination2 = destination2 {
            aCoder.encode(destination2.latitude, forKey: "destination2_lat")
            aCoder.encode(destination2.longitude, forKey: "destination2_long")
        }
    }
    
    func destinationDistanceFromLocation(_ location: CLLocation) -> Double {
        let rawDistance = Double(CLLocation(latitude: destination1.latitude, longitude: destination1.longitude).distance(from: location))
        return rawDistance / GHConstant.mileUnit
    }
    
}
