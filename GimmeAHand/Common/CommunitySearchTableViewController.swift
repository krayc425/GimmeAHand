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

class CommunitySearchTableViewController: UITableViewController {
    
    static func embeddedInNavigationController(_ parent: CommunitySearchTableViewControllerDelegate?, _ type: GHCommunitySearchType = .none) -> UINavigationController {
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
    
    var communities: [CommunityModel] = []
    var delegate: CommunitySearchTableViewControllerDelegate?
    var type: GHCommunitySearchType = .none
    var selectedCommunityIndexPath: IndexPath? {
        didSet {
            navigationItem.rightBarButtonItem?.isEnabled = selectedCommunityIndexPath != nil
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = type.title
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "communitySearchTableViewCellId")
        tableView.tableFooterView = UIView()
        
        let backBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(dismissAction))
        navigationItem.leftBarButtonItem = backBarButtonItem
        let doneBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneAction))
        navigationItem.rightBarButtonItem = doneBarButtonItem
        doneBarButtonItem.isEnabled = false
        
        doneBarButtonItem.addObserver(self, forKeyPath: "selectedCommunityIndexPath", options: .new, context: nil)
        
        locationManager.startUpdatingLocation()
        locationManager.delegate = self
        locationManager.requestLocation()
    }
    
    func reloadCommunites() {
        guard let location = currentLocation else {
            return
        }
        communities = MockDataStore.shared.communityList.sorted(by: { model1, model2 in
            model1.distanceFromLocation(location) < model2.distanceFromLocation(location)
        })
        if type != .filter {
            communities = communities.filter {
                $0.distanceFromLocation(location) <= 3.0
            }
        } 
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
            SVProgressHUD.showError(withStatus: "No locations found")
            return
        }
        currentLocation = location
        reloadCommunites()
        tableView.reloadData()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        SVProgressHUD.showError(withStatus: error.localizedDescription)
    }
    
}
