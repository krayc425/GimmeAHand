//
//  CategorySelectionTableViewController.swift
//  GimmeAHand
//
//  Created by Kuixi Song on 3/24/21.
//

import UIKit

protocol CategorySelectionTableViewControllerDelegate {
    
    func didSelectCategory(_ category: GHOrderCategory)
    
}

class CategorySelectionTableViewController: UITableViewController {
    
    static func embeddedInNavigationController(_ parent: CategorySelectionTableViewControllerDelegate?) -> UINavigationController {
        let categoryTableViewController = CategorySelectionTableViewController()
        categoryTableViewController.delegate = parent
        let navigationController = UINavigationController(rootViewController: categoryTableViewController)
        navigationController.navigationBar.prefersLargeTitles = true
        navigationController.navigationItem.largeTitleDisplayMode = .always
        return navigationController
    }
    
    let categories = GHOrderCategory.allCases
    
    var delegate: CategorySelectionTableViewControllerDelegate?
    var selectedCategoryIndexPath: IndexPath? {
        didSet {
            navigationItem.rightBarButtonItem?.isEnabled = selectedCategoryIndexPath != nil
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Select a Category"
        
        let backBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(dismissAction))
        navigationItem.leftBarButtonItem = backBarButtonItem
        let doneBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneAction))
        navigationItem.rightBarButtonItem = doneBarButtonItem
        doneBarButtonItem.isEnabled = false
        
        tableView.register(UINib(nibName: "CategorySelectionTableViewCell", bundle: nil), forCellReuseIdentifier: CategorySelectionTableViewCell.reuseIdentifier)
        tableView.tableFooterView = UIView()
    }
    
    @objc func dismissAction(_ sender: UIBarButtonItem) {
        navigationController?.dismiss(animated: true)
    }
    
    @objc func doneAction(_ sender: UIBarButtonItem) {
        navigationController?.dismiss(animated: true) { [weak self] in
            guard let strongSelf = self,
                  let selectedIndexPath = strongSelf.selectedCategoryIndexPath else {
                return
            }
            strongSelf.delegate?.didSelectCategory(strongSelf.categories[selectedIndexPath.row])
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CategorySelectionTableViewCell.reuseIdentifier, for: indexPath) as! CategorySelectionTableViewCell
        
        cell.config(categories[indexPath.row])
        
        if let selectedIndexPath = selectedCategoryIndexPath, selectedIndexPath == indexPath {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if let selectedIndexPath = selectedCategoryIndexPath, selectedIndexPath == indexPath {
            selectedCategoryIndexPath = nil
        } else {
            selectedCategoryIndexPath = indexPath
        }
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44.0
    }

}
