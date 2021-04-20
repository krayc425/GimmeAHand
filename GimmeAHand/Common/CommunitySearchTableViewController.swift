//
//  CommunitySearchTableViewController.swift
//  GimmeAHand
//
//  Created by Kuixi Song on 3/19/21.
//

import UIKit
import CoreLocation
import SVProgressHUD

protocol CommunitySearchTableViewControllerDelegate {
    
    func didSelectCommunity(_ community: CommunityModel)
    
}

enum CommunitySearchType {
    
    case none
    case add
    case filter
    
    var title: String {
        switch self {
        case .add:
            return "Add a Community"
        case .filter:
            return "Filter by Community"
        case .none:
            return ""
        }
    }
    
    var description: String? {
        switch self {
        case .add:
            return "We only display available communities within 3 miles of your current location."
        case .filter:
            return nil
        case .none:
            return nil
        }
    }
    
}

class CommunitySearchTableViewController: UITableViewController {
    
    static func embeddedInNavigationController(_ parent: CommunitySearchTableViewControllerDelegate?, _ type: CommunitySearchType = .none) -> UINavigationController {
        let communitySearchTableViewController = CommunitySearchTableViewController(style: .grouped)
        communitySearchTableViewController.delegate = parent
        communitySearchTableViewController.type = type
        let navigationController = UINavigationController(rootViewController: communitySearchTableViewController)
        navigationController.navigationBar.prefersLargeTitles = true
        navigationController.navigationItem.largeTitleDisplayMode = .always
        return navigationController
    }
    
    let locationManager = MapHelper.shared.locationManager
    var currentLocation: CLLocation? = nil
    
    let communities = MockDataStore.shared.communityList
    var delegate: CommunitySearchTableViewControllerDelegate?
    var type: CommunitySearchType = .none
    var selectedCommunityIndexPath: IndexPath? {
        didSet {
            navigationItem.rightBarButtonItem?.isEnabled = selectedCommunityIndexPath != nil
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = type.title
        
        let backBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(dismissAction))
        navigationItem.leftBarButtonItem = backBarButtonItem
        let doneBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneAction))
        navigationItem.rightBarButtonItem = doneBarButtonItem
        doneBarButtonItem.isEnabled = false
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "communitySearchTableViewCellId")
        tableView.tableFooterView = UIView()
        
        doneBarButtonItem.addObserver(self, forKeyPath: "selectedCommunityIndexPath", options: .new, context: nil)
        
        locationManager.startUpdatingLocation()
        locationManager.delegate = self
        locationManager.requestLocation()
    }
    
    @objc func dismissAction(_ sender: UIBarButtonItem) {
        navigationController?.dismiss(animated: true)
    }
    
    @objc func doneAction(_ sender: UIBarButtonItem) {
        navigationController?.dismiss(animated: true) { [weak self] in
            guard let strongSelf = self,
                  let selectedIndexPath = strongSelf.selectedCommunityIndexPath else {
                return
            }
            strongSelf.delegate?.didSelectCommunity(strongSelf.communities[selectedIndexPath.row])
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return communities.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "communitySearchTableViewCellId")

        let community = communities[indexPath.row]
        cell.textLabel?.text = community.name
        if let myLocation = currentLocation {
            cell.detailTextLabel?.text = "\(community.distanceFromLocation(myLocation).distanceString) from you"
        } else {
            cell.detailTextLabel?.text = "Calculating distance..."
        }
        cell.detailTextLabel?.textColor = .secondaryLabel
        cell.tintColor = .GHTint
        
        if let selectedIndexPath = selectedCommunityIndexPath, selectedIndexPath == indexPath {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }

        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if let selectedIndexPath = selectedCommunityIndexPath, selectedIndexPath == indexPath {
            selectedCommunityIndexPath = nil
        } else {
            selectedCommunityIndexPath = indexPath
        }
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return type.description
    }
    
}

extension CommunitySearchTableViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else {
            debugPrint("No Locations found")
            return
        }
        currentLocation = location
        tableView.reloadData()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        SVProgressHUD.showError(withStatus: error.localizedDescription)
        SVProgressHUD.dismiss(withDelay: GHConstant.kHUDDuration)
    }
    
}
