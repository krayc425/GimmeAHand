//
//  CreateOrderTableViewController.swift
//  GimmeAHand
//
//  Created by Chengyongping Lu on 3/20/21.
//

import UIKit
import CoreLocation
import SVProgressHUD

enum DestinationButtonTag: Int {
    
    case none = 0
    case first = 1
    case second = 2
    
}

class CreateOrderTableViewController: UITableViewController {

    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var timeLabel1: UILabel!
    @IBOutlet weak var timeLabel2: UILabel!
    @IBOutlet weak var startDateField: UIDatePicker!
    @IBOutlet weak var endDateField: UIDatePicker!
    @IBOutlet weak var tipTextField: UITextField!
    @IBOutlet weak var tipRecommendationLabel: UILabel!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var createButton: UIButton!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var categoryImageView: UIImageView!
    @IBOutlet weak var communityLabel: UILabel!
    @IBOutlet weak var destinationLabel1: UILabel!
    @IBOutlet weak var destinationLabel2: UILabel!
    @IBOutlet weak var destinationButton1: UIButton!
    @IBOutlet weak var destinationButton2: UIButton!
    @IBOutlet weak var destinationStackView2: UIStackView!
    @IBOutlet weak var paymentLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        descriptionTextView.delegate = self
        titleTextField.delegate = self
        tipTextField.delegate = self
        titleTextField.becomeFirstResponder()
        
        startDateField.minimumDate = Date()
        endDateField.minimumDate = Date()
        
        destinationButton1.tag = DestinationButtonTag.first.rawValue
        destinationButton2.tag = DestinationButtonTag.second.rawValue
        destinationStackView2.isHidden = true
        
        tipRecommendationLabel.text = "A recommended tip amount will be displayed here after you choose the category and destination."
        
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
    
    @IBAction func destinationAction(_ sender: UIButton) {
        performSegue(withIdentifier: "preciseSegue", sender: sender.tag)
    }
    
    func createOrder() {
        // TODO: Validation
        
        // mock data
        let randomCommunity = MockDataStore.shared.randomCommunity()
        let newOrder = OrderModel(name: "haha", description: "haha", amount: 2.30, status: .submitted, createDate: Date(), startDate: Date(), endDate: Date(), category: .shipping, community: randomCommunity, creator: UserHelper.shared.currentUser, courier: nil, destination1: randomCommunity.coordinate, destination2: nil)
        OrderHelper.shared.addOrder(newOrder)
        
        // create order logic
        SVProgressHUD.show(withStatus: "Creating order")
        SVProgressHUD.dismiss(withDelay: GHConstant.kHUDDuration) {
            NotificationCenter.default.post(name: .GHRefreshHomepage, object: nil)
            NotificationCenter.default.post(name: .GHRefreshMyOrders, object: nil)
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
            let communityViewController = CommunitySearchTableViewController.embeddedInNavigationController(self, .select)
            present(communityViewController, animated: true)
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
            guard let tagInteger = sender as? Int, let tag = DestinationButtonTag(rawValue: tagInteger) else {
                return
            }
            let destinationViewController = segue.destination as! PreciseLocationSearchViewController
            destinationViewController.delegate = self
            destinationViewController.tag = tag
        }
    }

}

extension CreateOrderTableViewController: CategorySelectionTableViewControllerDelegate {
    
    func didSelectCategory(_ category: GHOrderCategory) {
        categoryLabel.text = category.rawValue
        category.fill(in: &categoryImageView)
        let destinations = category.getDestinations()
        destinationLabel1.text = destinations[0]
        destinationButton1.setTitle("Select", for: .normal)
        switch category.getDestinations().count {
        case 1:
            destinationStackView2.isHidden = true
        case 2:
            destinationStackView2.isHidden = false
            destinationLabel2.text = destinations[1]
            destinationButton2.setTitle("Select", for: .normal)
        default:
            break
        }
    }
    
}

extension CreateOrderTableViewController: CommunitySearchTableViewControllerDelegate {
    
    func didSelectCommunity(_ community: CommunityModel) {
        communityLabel.text = community.name
    }
    
}

extension CreateOrderTableViewController: PaymentTableViewControllerDelegate {
    
    func didSelectPayment(_ payment: String) {
        paymentLabel.text = payment
    }
    
}

extension CreateOrderTableViewController: PreciseLocationSearchViewControllerDelegate {
    
    func didSelectLocation(_ name: String, _ tag: DestinationButtonTag) {
        switch tag {
        case .first:
            destinationButton1.setTitle(name, for: .normal)
        case .second:
            destinationButton2.setTitle(name, for: .normal)
        default:
            return
        }
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
