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
    let randomized = (Double.random(in: -1...1) / 10.0, Double.random(in: -1...1) / 10.0)
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
        oldUserLocation = userLocation
        mapView.removeAnnotations(mapView.annotations)
        mapView.removeOverlays(mapView.overlays)
        
        // mock destination
        let destination = CLLocationCoordinate2D(latitude: userLocation.coordinate.latitude + randomized.0,
                                                 longitude: userLocation.coordinate.longitude + randomized.1)
        let targetAnnotation = GHTargetAnnotation(targetName: orderModel?.name ?? "",
                                                  coordinate: destination)
        mapView.addAnnotation(targetAnnotation)
        mapView.showAnnotations([targetAnnotation, userLocation], animated: true)
        
        // add route
        addRoute(source: userLocation.coordinate, destination: destination)
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
                strongSelf.navigationItem.title = "ETA: \(response.expectedTravelTime.formattedETAString)"
            }
        }
    }

    @IBAction func navigationAction(_ sender: UIButton) {
        guard let model = orderModel else {
            return
        }
        MapHelper.shared.navigate(37.0, -122.0, model.name)
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
