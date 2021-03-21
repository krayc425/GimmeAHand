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
    
    @IBOutlet weak var selectTypeButton: UIButton!
    @IBOutlet weak var selectCommunityButton: UIButton!
    @IBOutlet weak var selectPayingOptionButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        descriptionTextField.placeholder = "Detailed Description (Optional)"
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
    
    @IBAction func selectTypeAction(_ sender: UIButton) {
        guard sender == selectTypeButton else {
            debugPrint("Invalid Button!")
            return
        }
        debugPrint("Select Type!")
    }
    
    @IBAction func selectCommunityAction(_ sender: UIButton) {
        guard sender == selectCommunityButton else {
            debugPrint("Invalid Button!")
            return
        }
        debugPrint("Select Community!")
    }
    
    @IBAction func selectPayingOptionAction(_ sender: UIButton) {
        guard sender == selectPayingOptionButton else {
            debugPrint("Invalid Button!")
            return
        }
        debugPrint("Select Paying Option!")
    }

}
