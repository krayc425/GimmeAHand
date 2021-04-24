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
    @IBOutlet weak var orderReceiverLabel: UILabel!
    @IBOutlet weak var orderCreaterLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var fullMapButton: UIButton!
    @IBOutlet weak var actionButton: UIButton!
    
    var orderModel: OrderModel? = nil
    var isFromHomepage: Bool = false
    let locationManager = MapHelper.shared.locationManager
    
    let randomized = (Double.random(in: -1...1) / 10.0, Double.random(in: -1...1) / 10.0)
    var oldUserLocation: MKUserLocation = MKUserLocation()
    
    var actionButtonHandler: (() -> ())? = nil

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
        guard var model = orderModel else {
            return
        }
        title = model.name
        
        categoryLabel.text = model.category.rawValue
        model.category.fill(in: &categoryImageView)
        model.status.decorate(&statusLabel)
        if model.orderDescription.isEmpty {
            descriptionLabel.text = "N/A"
        } else {
            descriptionLabel.text = model.orderDescription
        }
        validDateLabel.text = model.validDateString
        amountLabel.text = model.amountString
        orderCreaterLabel.text = model.creator.firstName
        
        if let courier = model.courier {
            orderReceiverLabel.text = courier.firstName
        }
        
        switch model.status {
        case .submitted:
            // check whether this order is being viewed by order creator or courier
            // if creator
            if model.creator == UserHelper.shared.currentUser {
                actionButton.setTitle("Cancel Order", for: .normal)
                actionButton.backgroundColor = .red
                actionButtonHandler = { [weak self] in
                    guard let strongSelf = self else {
                        return
                    }
                    let alert = UIAlertController(title: "Cancel this Order?", message: nil, preferredStyle: .actionSheet)
                    alert.addAction(UIAlertAction(title: "Cancel it!", style: .destructive, handler: { _ in
                        
                        OrderHelper.shared.cancelOrder(&model)
                        
                        // cancel order logic
                        SVProgressHUD.show(withStatus: "Cancelling order")
                        SVProgressHUD.dismiss(withDelay: GHConstant.kHUDDuration) {
                            NotificationCenter.default.post(name: .GHRefreshHomepage, object: nil)
                            NotificationCenter.default.post(name: .GHRefreshMyOrders, object: nil)
                            strongSelf.navigationController?.popViewController(animated: true)
                        }
                    }))
                    alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
                    strongSelf.present(alert, animated: true)
                }
            } else {
                // if courier
                actionButton.setTitle("Take Order", for: .normal)
                actionButton.backgroundColor = .GHTint
                actionButtonHandler = { [weak self] in
                    guard let strongSelf = self else {
                        return
                    }
                    let alert = UIAlertController(title: "Take this Order?", message: nil, preferredStyle: .actionSheet)
                    alert.addAction(UIAlertAction(title: "Take it!", style: .default, handler: { _ in
                        
                        OrderHelper.shared.takeOrder(&model, UserHelper.shared.currentUser)
                        
                        // take order logic
                        SVProgressHUD.show(withStatus: "Taking order")
                        SVProgressHUD.dismiss(withDelay: GHConstant.kHUDDuration) {
                            NotificationCenter.default.post(name: .GHRefreshHomepage, object: nil)
                            NotificationCenter.default.post(name: .GHRefreshMyOrders, object: nil)
                            strongSelf.navigationController?.popViewController(animated: true)
                        }
                    }))
                    alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
                    strongSelf.present(alert, animated: true)
                }
            }
        case .inprogress:
            guard let courier = model.courier else {
                return
            }
            if courier == UserHelper.shared.currentUser {
                // check whether this order is being viewed by order courier
                actionButton.setTitle("Mark Order as Finished", for: .normal)
                actionButton.backgroundColor = .GHTint
                actionButtonHandler = { [weak self] in
                    guard let strongSelf = self else {
                        return
                    }
                    let alert = UIAlertController(title: "Mark this order as finished?", message: nil, preferredStyle: .actionSheet)
                    alert.addAction(UIAlertAction(title: "Mark it!", style: .default, handler: { _ in
                        
                        OrderHelper.shared.finishOrder(&model)
                        
                        // finish order logic
                        SVProgressHUD.show(withStatus: "Marking order")
                        SVProgressHUD.dismiss(withDelay: GHConstant.kHUDDuration) {
                            NotificationCenter.default.post(name: .GHRefreshMyOrders, object: nil)
                            strongSelf.navigationController?.popViewController(animated: true)
                        }
                    }))
                    alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
                    strongSelf.present(alert, animated: true)
                }
            }
        case .finished:
            if model.creator == UserHelper.shared.currentUser {
                // check whether this order is being viewed by order creator
                actionButton.setTitle("Report a Problem", for: .normal)
                actionButton.backgroundColor = .clear
                debugPrint("I wanna report a problem")
            }
        case .cancelled:
            break
        }
    }
    
    func updateUserLocation(_ userLocation: MKUserLocation) {
        if userLocation == oldUserLocation {
            return
        }
        guard let model = orderModel else {
            return
        }
        oldUserLocation = userLocation
        mapView.removeAnnotations(mapView.annotations)
        
        let targetAnnotation = GHTargetAnnotation(targetName: model.name,
                                                  coordinate: model.destination1)
        mapView.addAnnotation(targetAnnotation)
        mapView.showAnnotations([targetAnnotation], animated: true)
    }
    
    @IBAction func orderAction(_ sender: UIButton) {
        actionButtonHandler?()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let model = orderModel else {
            return 0
        }
        switch section {
        case 0:
            return 1
        case 1:
            return 6
        case 2:
            switch model.status {
            case .finished:
                return 2
            case .inprogress:
                return 3
            default:
                return 0
            }
        case 3:
            return model.status == .finished ? 0 : 1
        default:
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        if let model = orderModel, section == 0 && !model.isInProgress {
            return "This map only shows an approximate location of the order destination. \nA precise location will be displayed after you take this order."
        } else {
            return nil
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.section == 2 && indexPath.row == 2 {
            guard let phone = phoneLabel.text, !phone.isEmpty,
                  let url = URL(string: "tel://\(phone)") else {
                return
            }
            UIApplication.shared.open(url, options: [:])
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
