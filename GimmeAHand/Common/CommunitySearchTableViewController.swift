//
//  CommunitySearchTableViewController.swift
//  GimmeAHand
//
//  Created by Kuixi Song on 3/19/21.
//

import UIKit

protocol CommunitySearchTableViewControllerDelegate {
    
    func didSelectCommunity(_ community: String)
    
}

class CommunitySearchTableViewController: UITableViewController {
    
    static func embeddedInNavigationController(_ parent: CommunitySearchTableViewControllerDelegate?, _ title: String? = nil) -> UINavigationController {
        let communitySearchTableViewController = CommunitySearchTableViewController()
        communitySearchTableViewController.delegate = parent
        if let title = title {
            communitySearchTableViewController.title = title
        } else {
            communitySearchTableViewController.title = "Select a Community"
        }
        let navigationController = UINavigationController(rootViewController: communitySearchTableViewController)
        navigationController.navigationBar.prefersLargeTitles = true
        navigationController.navigationItem.largeTitleDisplayMode = .always
        return navigationController
    }
    
    let communities = ["CMU Pittsburgh", "CMU SV", "Kenmwar Apartment", "Avalon Mountain View"]
    var delegate: CommunitySearchTableViewControllerDelegate?
    var selectedCommunityIndexPath: IndexPath? {
        didSet {
            navigationItem.rightBarButtonItem?.isEnabled = selectedCommunityIndexPath != nil
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let backBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(dismissAction))
        navigationItem.leftBarButtonItem = backBarButtonItem
        let doneBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneAction))
        navigationItem.rightBarButtonItem = doneBarButtonItem
        doneBarButtonItem.isEnabled = false
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "communitySearchTableViewCellId")
        tableView.tableFooterView = UIView()
        
        doneBarButtonItem.addObserver(self, forKeyPath: "selectedCommunityIndexPath", options: .new, context: nil)
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

        cell.textLabel?.text = communities[indexPath.row]
        cell.detailTextLabel?.text = "0.5 miles from you"
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
    
}
