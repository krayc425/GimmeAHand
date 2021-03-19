//
//  LoginTableViewController.swift
//  GimmeAHand
//
//  Created by Kuixi Song on 3/12/21.
//

import UIKit
import SVProgressHUD

class LoginTableViewController: UITableViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var rememberMeSwitch: UISwitch!
    @IBOutlet weak var faceIDSwitch: UISwitch!
    @IBOutlet weak var loginButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        [emailTextField, passwordTextField].forEach { (textField) in
            textField?.delegate = self
        }
    }
    
    @IBAction func loginAction(_ sender: UIButton) {
        guard sender == loginButton else {
            debugPrint("Invalid Button!")
            return
        }
        login()
    }
    
    func login() {
        // TODO: Add login logic
        debugPrint("Login!!!")
        SVProgressHUD.show(withStatus: "Login")
        SVProgressHUD.dismiss(withDelay: kHUDDuration)
    }

}

extension LoginTableViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailTextField {
            emailTextField.resignFirstResponder()
            passwordTextField.becomeFirstResponder()
        } else if textField == passwordTextField {
            passwordTextField.resignFirstResponder()
            login()
        }
        return true
    }
    
}
