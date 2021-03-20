//
//  OrderMapViewController.swift
//  GimmeAHand
//
//  Created by Kuixi Song on 3/20/21.
//

import UIKit
import MapKit

class OrderMapViewController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    let locationManager = MapHelper.shared.locationManager

    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        locationManager.startUpdatingLocation()
        mapView.showsUserLocation = true
        
        updateUserLocation(mapView.userLocation)
    }
    
    func updateUserLocation(_ userLocation: MKUserLocation) {
        // clear old annotations and overlays
        mapView.removeAnnotations(mapView.annotations)
        mapView.removeOverlays(mapView.overlays)
        
        // mock destination
        let destination = CLLocationCoordinate2D(latitude: userLocation.coordinate.latitude + Double.random(in: 0...1),
                                                 longitude: userLocation.coordinate.longitude + Double.random(in: 0...1))
        let targetAnnotation = MKPointAnnotation()
        targetAnnotation.coordinate = destination
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
        let direction = MKDirections(request: directionRequest)
        direction.calculate { [weak self] (response, error) in
            if let error = error {
                debugPrint(error.localizedDescription)
            } else {
                let route = response!.routes[0] as MKRoute
                DispatchQueue.main.async {
                    self?.mapView.addOverlay(route.polyline)
                }
            }
        }
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
    
}
