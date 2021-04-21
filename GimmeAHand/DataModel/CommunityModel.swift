//
//  CommunityModel.swift
//  GimmeAHand
//
//  Created by Kuixi Song on 4/19/21.
//

import UIKit
import CoreLocation

class CommunityModel: NSObject {

    var name: String
    var coordinate: CLLocationCoordinate2D
    
    init(_ name: String,
         _ latitude: Double,
         _ longitude: Double) {
        self.name = name
        self.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    func distanceFromLocation(_ location: CLLocation) -> Double {
        let rawDistance = Double(CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude).distance(from: location))
        return rawDistance / 1609.344
    }
    
    convenience override init() {
        self.init("", 0.0, 0.0)
    }
    
}
