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
    @IBOutlet weak var fullMapButton: UIButton!
    @IBOutlet weak var navigateButton: UIButton!
    
    var orderModel: OrderModel? = nil
    let locationManager = MapHelper.shared.locationManager

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = UITableView.automaticDimension
        
        [mapView, fullMapButton, navigateButton].forEach {
            $0?.setRoundCorner()
        }
        
        setupMapView()
        setupOrderModel()
    }
    
    func setupMapView() {
        mapView.delegate = self
        locationManager.startUpdatingLocation()
        mapView.showsUserLocation = true
        
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
    
    @IBAction func navigateAction(_ sender: UIButton) {
        guard let model = orderModel, sender == navigateButton else {
            return
        }
        debugPrint("navigate!")
        // TODO: add navigation logic
        MapHelper.shared.navigate(37.0, -122.0, model.name)
    }

}

extension OrderDetailTableViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        updateUserLocation(userLocation)
    }
    
}
