//
//  PreciseLocationSearchViewController.swift
//  GimmeAHand
//
//  Created by Kuixi Song on 3/31/21.
//

import UIKit
import MapKit

protocol PreciseLocationSearchViewControllerDelegate {
    
    func didSelectLocation(_ name: String)
    
}

class PreciseLocationSearchViewController: UIViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var doneBarButtonItem: UIBarButtonItem!
    
    let locationManager = MapHelper.shared.locationManager
    var delegate: PreciseLocationSearchViewControllerDelegate?
    
    var selectedAnnotation: MKPointAnnotation? = nil {
        didSet {
            doneBarButtonItem.isEnabled = selectedAnnotation != nil
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        doneBarButtonItem.isEnabled = false
        
        searchBar.delegate = self
        mapView.delegate = self
        locationManager.startUpdatingLocation()
        mapView.showsUserLocation = true
    }
    
    func updateUserLocation(_ userLocation: MKUserLocation) {
        let span = MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5)
        let region = MKCoordinateRegion(center: userLocation.coordinate, span: span)
        mapView.setRegion(region, animated: true)
    }
    
    func searchLocation(with keyword: String) {
        let searchRequest = MKLocalSearch.Request()
        searchRequest.naturalLanguageQuery = keyword

        // Set the region to an associated map view's region.
        searchRequest.region = mapView.region

        let search = MKLocalSearch(request: searchRequest)
        search.start { [weak self] (response, error) in
            guard let response = response else {
                // Handle the error.
                return
            }
            DispatchQueue.main.async {
                self?.updateMapViewAnnotations(response.mapItems)
            }
//            for item in response.mapItems {
//                if let name = item.name,
//                    let location = item.placemark.location {
//                    debugPrint("\(name): \(location.coordinate.latitude),\(location.coordinate.longitude)")
//                }
//            }
        }
    }
    
    func updateMapViewAnnotations(_ items: [MKMapItem]) {
        mapView.removeAnnotations(mapView.annotations)
        var newAnnotations: [MKPointAnnotation] = []
        for item in items {
            if let name = item.name,
                let location = item.placemark.location {
                let annotation = MKPointAnnotation()
                annotation.coordinate = location.coordinate
                annotation.title = name
                newAnnotations.append(annotation)
            }
        }
        mapView.showAnnotations(newAnnotations, animated: true)
    }

    @IBAction func doneAction(_ sender: UIBarButtonItem) {
        guard let selectedAnnotation = selectedAnnotation,
              sender == doneBarButtonItem, sender.isEnabled else {
            return
        }
        delegate?.didSelectLocation(selectedAnnotation.title ?? "")
        navigationController?.popViewController(animated: true)
    }
    
}

extension PreciseLocationSearchViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        updateUserLocation(userLocation)
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        guard let pointAnnotation = view.annotation as? MKPointAnnotation else {
            return
        }
        selectedAnnotation = pointAnnotation
    }
    
}

extension PreciseLocationSearchViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let keyword = searchBar.text, !keyword.isEmpty else {
            return
        }
        searchLocation(with: keyword)
    }
    
}
