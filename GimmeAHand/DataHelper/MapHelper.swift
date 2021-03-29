//
//  MapHelper.swift
//  GimmeAHand
//
//  Created by Kuixi Song on 3/20/21.
//

import UIKit
import MapKit

class MapHelper: NSObject {
    
    static let shared: MapHelper = MapHelper()
    var locationManager: CLLocationManager {
        get {
            let locationManager = CLLocationManager()
            if locationManager.authorizationStatus != .authorizedWhenInUse {
                locationManager.requestWhenInUseAuthorization()
            }
            locationManager.desiredAccuracy = kCLLocationAccuracyReduced
            locationManager.distanceFilter = kCLDistanceFilterNone
            return locationManager
        }
    }
    
    private override init() {
        
    }
    
    func navigate(_ latitude: Double, _ longitude: Double, _ name: String) {
        let coordinate = CLLocationCoordinate2DMake(latitude, longitude)
        let mapItem = MKMapItem(placemark: MKPlacemark(coordinate: coordinate))
        mapItem.name = name
        mapItem.openInMaps(launchOptions: [MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving])
    }

}
