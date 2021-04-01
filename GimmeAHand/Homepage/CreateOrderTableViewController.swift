//
//  CreateOrderTableViewController.swift
//  GimmeAHand
//
//  Created by Chengyongping Lu on 3/20/21.
//

import UIKit
import SVProgressHUD

class CreateOrderTableViewController: UITableViewController {

    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var startDateField: UIDatePicker!
    @IBOutlet weak var endDateField: UIDatePicker!
    @IBOutlet weak var tipTextField: UITextField!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var createButton: UIButton!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var categoryImageView: UIImageView!
    @IBOutlet weak var communityLabel: UILabel!
    @IBOutlet weak var preciseLocationLabel: UILabel!
    @IBOutlet weak var paymentLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        descriptionTextView.delegate = self
        titleTextField.delegate = self
        tipTextField.delegate = self
        titleTextField.becomeFirstResponder()
        
        startDateField.minimumDate = Date()
        endDateField.minimumDate = Date()
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 44.0
        
        let backBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(dismissAction))
        navigationItem.leftBarButtonItem = backBarButtonItem
    }
    
    @objc func dismissAction(_ sender: UIBarButtonItem) {
        navigationController?.dismiss(animated: true)
    }

    @IBAction func createAction(_ sender: UIButton) {
        guard sender == createButton else {
            debugPrint("Invalid Button!")
            return
        }
        createOrder()
    }
    
    func createOrder() {
        // TODO: create order logic
        SVProgressHUD.show(withStatus: "Creating order")
        SVProgressHUD.dismiss(withDelay: GHConstant.kHUDDuration) {
            self.navigationController?.dismiss(animated: true)
        }
    }
    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch indexPath.row {
        case 1:
            let categoryViewController = CategorySelectionTableViewController.embeddedInNavigationController(self)
            present(categoryViewController, animated: true)
        case 4:
            let communityViewController = CommunitySearchTableViewController.embeddedInNavigationController(self)
            present(communityViewController, animated: true)
        case 5:
            performSegue(withIdentifier: "preciseSegue", sender: nil)
        case 6:
            let paymentViewController = PaymentTableViewController.embeddedInNavigationController(self)
            present(paymentViewController, animated: true)
        default:
            break
        }
    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "preciseSegue" {
            let destinationViewController = segue.destination as! PreciseLocationSearchViewController
            destinationViewController.delegate = self
        }
    }


}

extension CreateOrderTableViewController: CategorySelectionTableViewControllerDelegate {
    
    func didSelectCategory(_ category: GHOrderCategory) {
        categoryLabel.text = category.rawValue
        category.fill(in: &categoryImageView)
    }
    
}

extension CreateOrderTableViewController: CommunitySearchTableViewControllerDelegate {
    
    func didSelectCommunity(_ community: String) {
        communityLabel.text = community
    }
    
}

extension CreateOrderTableViewController: PaymentTableViewControllerDelegate {
    
    func didSelectPayment(_ payment: String) {
        paymentLabel.text = payment
    }
    
}

extension CreateOrderTableViewController: PreciseLocationSearchViewControllerDelegate {
    
    func didSelectLocation(_ name: String) {
        preciseLocationLabel.text = name
    }
    
}

extension CreateOrderTableViewController: UITextFieldDelegate {
 
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}

extension CreateOrderTableViewController: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        var newSize = textView.sizeThatFits(CGSize(width: view.bounds.width - 40.0, height: CGFloat.greatestFiniteMagnitude))
        if newSize.height < 44 {
            newSize.height = 44
        }
        tableView.beginUpdates()
        tableView.endUpdates()
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        textView.resignFirstResponder()
    }
    
}
