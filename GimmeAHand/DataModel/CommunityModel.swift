//
//  CommunityModel.swift
//  GimmeAHand
//
//  Created by Kuixi Song on 4/19/21.
//

import UIKit
import CoreLocation

class CommunityModel: NSObject, NSSecureCoding {
    
    static var supportsSecureCoding = true

    var name: String
    var coordinate: CLLocationCoordinate2D
    
    init(_ name: String,
         _ latitude: Double,
         _ longitude: Double) {
        self.name = name
        self.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    convenience override init() {
        self.init("", 0.0, 0.0)
    }
    
    func encode(with coder: NSCoder) {
        coder.encode(name, forKey: "name")
        coder.encode(coordinate.latitude, forKey: "latitude")
        coder.encode(coordinate.longitude, forKey: "longitude")
    }
    
    required convenience init(coder: NSCoder) {
        let name = coder.decodeObject(forKey: "name") as! String
        let latitude = coder.decodeDouble(forKey: "latitude")
        let longitude = coder.decodeDouble(forKey: "longitude")
        self.init(name, latitude, longitude)
    }
    
    static func ==(_ lhs: CommunityModel, _ rhs: CommunityModel) -> Bool {
        return lhs.name == rhs.name
            && lhs.coordinate.latitude == rhs.coordinate.latitude
            && lhs.coordinate.longitude == rhs.coordinate.longitude
    }
    
    func distanceFromLocation(_ location: CLLocation) -> Double {
        let rawDistance = Double(CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude).distance(from: location))
        return rawDistance / 1609.344
    }
    
}
