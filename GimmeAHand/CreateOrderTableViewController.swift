//
//  CreateOrderTableViewController.swift
//  GimmeAHand
//
//  Created by Chengyongping Lu on 3/20/21.
//

import UIKit

class CreateOrderTableViewController: UITableViewController {

    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var startDateField: UIDatePicker!
    @IBOutlet weak var endDateField: UIDatePicker!
    @IBOutlet weak var tipTextField: UITextField!
    @IBOutlet weak var descriptionTextField: UITextField!
    @IBOutlet weak var createButton: UIButton!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var communityLabel: UILabel!
    @IBOutlet weak var paymentLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let backBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(dismissAction))
        navigationItem.leftBarButtonItem = backBarButtonItem
        
        descriptionTextField.placeholder = "Detailed Description (Optional)"
    }
    
    @objc func dismissAction(_ sender: UIBarButtonItem) {
        navigationController?.dismiss(animated: true, completion: nil)
    }

    @IBAction func createAction(_ sender: UIButton) {
        guard sender == createButton else {
            debugPrint("Invalid Button!")
            return
        }
        createOrder()
    }
    
    func createOrder() {
        debugPrint("Create order!")
    }
    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch indexPath.row {
        case 1:
            debugPrint("Select category")
        case 4:
            debugPrint("Select community")
            let communityViewController = CommunitySearchTableViewController.embeddedInNavigationController(self)
            present(communityViewController, animated: true)
        case 5:
            debugPrint("Select payment")
        default:
            break
        }
    }

}

extension CreateOrderTableViewController: CommunitySearchTableViewControllerDelegate {
    
    func didSelectCommunity(_ community: String) {
        communityLabel.text = community
    }
    
}
