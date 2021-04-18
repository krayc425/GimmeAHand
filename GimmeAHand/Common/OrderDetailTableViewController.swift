//
//  OrderDetailTableViewController.swift
//  GimmeAHand
//
//  Created by Yue Xu on 3/19/21.
//

import UIKit
import MapKit
import SVProgressHUD

class OrderDetailTableViewController: UITableViewController {

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var statusLabel: GHStatusLabel!
    @IBOutlet weak var validDateLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var categoryImageView: UIImageView!
    @IBOutlet weak var orderRecieverLabel: UILabel!
    @IBOutlet weak var orderCreaterLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var fullMapButton: UIButton!
    
    var orderModel: OrderModel? = nil
    var isFromHomepage: Bool = false
    let locationManager = MapHelper.shared.locationManager
    
    let randomized = (Double.random(in: -1...1) / 10.0, Double.random(in: -1...1) / 10.0)
    var oldUserLocation: MKUserLocation = MKUserLocation()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = UITableView.automaticDimension
        
        [mapView, fullMapButton].forEach {
            $0?.setRoundCorner()
        }
        
        setupMapView()
        setupOrderModel()
    }
    
    func setupMapView() {
        mapView.delegate = self
        locationManager.startUpdatingLocation()
        mapView.showsUserLocation = true
        mapView.register(GHTargetMarkerView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
        
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
        validDateLabel.text = model.validDateString
        amountLabel.text = model.amountString
    }
    
    func updateUserLocation(_ userLocation: MKUserLocation) {
        if userLocation == oldUserLocation {
            return
        }
        oldUserLocation = userLocation
        mapView.removeAnnotations(mapView.annotations)
        
        let destination = CLLocationCoordinate2D(latitude: userLocation.coordinate.latitude + randomized.0,
                                                 longitude: userLocation.coordinate.longitude + randomized.1)
        let targetAnnotation = GHTargetAnnotation(targetName: orderModel?.name ?? "",
                                                  coordinate: destination)
        mapView.addAnnotation(targetAnnotation)
        mapView.showAnnotations([targetAnnotation], animated: true)
    }
    
    @IBAction func takeOrderAction(_ sender: UIButton) {
        guard isFromHomepage else {
            return
        }
        // TODO: take order logic
        SVProgressHUD.show(withStatus: "Taking order")
        SVProgressHUD.dismiss(withDelay: GHConstant.kHUDDuration) {
            self.navigationController?.popViewController(animated: true)
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return isFromHomepage ? 3 : 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            guard let model = orderModel else {
                return 0
            }
            if isFromHomepage {
                return 5
            } else {
                return 6 + (model.isTaken ? 1 : 0)
            }
        case 2:
            return isFromHomepage ? 1 : 0
        default:
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        if let model = orderModel, section == 0 && !model.isTaken {
            return "This map only shows an approximate location of the order destination. \nA precise location will be displayed after you take this order."
        } else {
            return nil
        }
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "fullMapSegue" {
            let mapViewController = segue.destination as! OrderMapViewController
            mapViewController.orderModel = orderModel
        }
    }

}

extension OrderDetailTableViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        updateUserLocation(userLocation)
    }
    
}
