//
//  RegisterTableViewController.swift
//  GimmeAHand
//
//  Created by Chengyongping Lu on 3/19/21.
//

import UIKit

class RegisterTableViewController: UITableViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var mobileTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmTextField: UITextField!
    
    @IBOutlet weak var addCommunityButton: UIButton!
    @IBOutlet weak var registerButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        [emailTextField, firstNameTextField, lastNameTextField, mobileTextField, passwordTextField, confirmTextField].forEach { (textField) in
            textField?.delegate = self
        }
    }
    
    @IBAction func registerAction(_ sender: UIButton) {
        guard sender == registerButton else {
            debugPrint("Invalid Button!")
            return
        }
        register()
    }
    
    func register() {
        debugPrint("Register!!")
    }

}

extension RegisterTableViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailTextField {
            emailTextField.resignFirstResponder()
            firstNameTextField.becomeFirstResponder()
        } else if textField == firstNameTextField {
            firstNameTextField.resignFirstResponder()
            lastNameTextField.becomeFirstResponder()
        } else if textField == lastNameTextField {
            lastNameTextField.resignFirstResponder()
            mobileTextField.becomeFirstResponder()
        } else if textField == mobileTextField {
            mobileTextField.resignFirstResponder()
            passwordTextField.becomeFirstResponder()
        } else if textField == passwordTextField {
            passwordTextField.resignFirstResponder()
            confirmTextField.becomeFirstResponder()
        } else {
            confirmTextField.resignFirstResponder()
        }
        return true
    }
    
}
