//
//  OrderDetailTableViewController.swift
//  GimmeAHand
//
//  Created by Yue Xu on 3/19/21.
//

import UIKit
import MapKit

class OrderDetailTableViewController: UITableViewController {

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var createdDateLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var categoryImageView: UIImageView!
    @IBOutlet weak var orderRecieverLabel: UILabel!
    @IBOutlet weak var orderCreaterLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    var orderModel: OrderModel? = nil
    let locationManager = CLLocationManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = UITableView.automaticDimension
        
        setupMapView()
        setupOrderModel()
    }
    
    func setupMapView() {
        mapView.delegate = self
        mapView.showsUserLocation = true
        
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyReduced
        locationManager.distanceFilter = kCLDistanceFilterNone
        locationManager.startUpdatingLocation()
        
        updateUserLocation(mapView.userLocation)
    }
    
    func setupOrderModel() {
        guard let model = orderModel else {
            return
        }
        title = model.name
        
        categoryLabel.text = model.category.rawValue
        model.category.fill(in: &categoryImageView)
        model.status.decorate(&statusLabel)
        if model.orderDescription.count == 0 {
            descriptionLabel.text = "N/A"
        } else {
            descriptionLabel.text = model.orderDescription
        }
        createdDateLabel.text = model.createdDateString
        amountLabel.text = model.amountString
    }
    
    func updateUserLocation(_ userLocation: MKUserLocation) {
        let span = MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5)
        let region = MKCoordinateRegion(center: userLocation.coordinate, span: span)
        mapView.setRegion(region, animated: true)
    }

}

extension OrderDetailTableViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        updateUserLocation(userLocation)
    }
    
}
