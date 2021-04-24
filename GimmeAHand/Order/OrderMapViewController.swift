//
//  OrderMapViewController.swift
//  GimmeAHand
//
//  Created by Kuixi Song on 3/20/21.
//

import UIKit
import MapKit

class GHTargetMarkerView: MKMarkerAnnotationView {
    
    override var annotation: MKAnnotation? {
        willSet {
            canShowCallout = true
            calloutOffset = CGPoint(x: -5, y: 5)
            rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
    }
    
}

class GHTargetAnnotation: NSObject, MKAnnotation {

    let locationName: String?
    let coordinate: CLLocationCoordinate2D
    
    var title: String? {
        return locationName
    }
    var subtitle: String? {
        return "0.5 mile from you"
    }

    init(targetName: String, coordinate: CLLocationCoordinate2D) {
        self.locationName = targetName
        self.coordinate = coordinate
        super.init()
    }
    
}


class OrderMapViewController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var navigateButton: UIButton!
    
    let locationManager = MapHelper.shared.locationManager
    
    var orderModel: OrderModel?
    var totalETA: Double = 0.0 {
        didSet {
            navigationItem.title = "ETA: \(totalETA.formattedETAString)"
        }
    }
    var oldUserLocation: MKUserLocation = MKUserLocation()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        locationManager.startUpdatingLocation()
        mapView.showsUserLocation = true
        mapView.register(GHTargetMarkerView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
        navigateButton.setRoundCorner()
        
        updateUserLocation(mapView.userLocation)
    }
    
    func updateUserLocation(_ userLocation: MKUserLocation) {
        // clear old annotations and overlays
        if userLocation == oldUserLocation {
            return
        }
        guard let model = orderModel else {
            return
        }
        oldUserLocation = userLocation
        mapView.removeAnnotations(mapView.annotations)
        mapView.removeOverlays(mapView.overlays)
        
        if let destination2 = model.destination2 {
            let targetAnnotation = GHTargetAnnotation(targetName: model.name,
                                                      coordinate: model.destination1)
            let targetAnnotation2 = GHTargetAnnotation(targetName: model.name,
                                                       coordinate: destination2)
            mapView.addAnnotations([targetAnnotation, targetAnnotation2])
            mapView.showAnnotations([targetAnnotation, targetAnnotation2, userLocation], animated: true)
            addRoute(source: userLocation.coordinate, destination: model.destination1)
            addRoute(source: model.destination1, destination: destination2)
        } else {
            let targetAnnotation = GHTargetAnnotation(targetName: model.name,
                                                      coordinate: model.destination1)
            mapView.addAnnotation(targetAnnotation)
            mapView.showAnnotations([targetAnnotation, userLocation], animated: true)
            addRoute(source: userLocation.coordinate, destination: model.destination1)
        }
    }
    
    func addRoute(source: CLLocationCoordinate2D, destination: CLLocationCoordinate2D) {
        let sourceItem = MKMapItem(placemark: MKPlacemark(coordinate: source))
        let destinationItem = MKMapItem(placemark: MKPlacemark(coordinate: destination))
        let directionRequest = MKDirections.Request()
        directionRequest.source = sourceItem
        directionRequest.destination = destinationItem
        directionRequest.transportType = .automobile
        // Calculate route
        let direction = MKDirections(request: directionRequest)
        direction.calculate { [weak self] (response, error) in
            if let error = error {
                debugPrint(error.localizedDescription)
            } else {
                guard let route = response?.routes.first else {
                    return
                }
                DispatchQueue.main.async {
                    self?.mapView.addOverlay(route.polyline)
                }
            }
        }
        // Calculate ETA
        let directionETA = MKDirections(request: directionRequest)
        directionETA.calculateETA { [weak self] (response, error) in
            guard let strongSelf = self else {
                return
            }
            if let error = error {
                debugPrint(error.localizedDescription)
            } else {
                guard let response = response else {
                    return
                }
                strongSelf.totalETA += response.expectedTravelTime
            }
        }
    }

    @IBAction func navigationAction(_ sender: UIButton) {
        guard let model = orderModel else {
            return
        }
        MapHelper.shared.navigate(model.destination1.latitude, model.destination1.longitude, model.name)
    }
    
}

extension OrderMapViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        updateUserLocation(userLocation)
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let lineRenderer = MKPolylineRenderer(overlay: overlay)
        lineRenderer.strokeColor = .systemBlue
        lineRenderer.lineWidth = 5
        return lineRenderer
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        guard let annotation = view.annotation as? GHTargetAnnotation else {
            return
        }
        MapHelper.shared.navigate(annotation.coordinate.latitude, annotation.coordinate.longitude, annotation.title ?? "")
    }
    
}
