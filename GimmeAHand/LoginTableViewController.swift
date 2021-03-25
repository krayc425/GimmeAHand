//
//  LoginTableViewController.swift
//  GimmeAHand
//
//  Created by Kuixi Song on 3/12/21.
//

import UIKit
import LocalAuthentication
import SVProgressHUD

class LoginTableViewController: AuthenticateTableViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var rememberMeSwitch: UISwitch!
    @IBOutlet weak var faceIDSwitch: UISwitch!
    @IBOutlet weak var loginButton: UIButton!
    
    let context = LAContext()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        faceIDSwitch.isOn = false
        
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
        if faceIDSwitch.isOn {
            beginFaceID()
            return
        }
        SVProgressHUD.show(withStatus: "Login")
        SVProgressHUD.dismiss(withDelay: GHConstant.kStoryboardTransitionDuration) {
            super.transitionToMain()
        }
    }
    
    func beginFaceID() {
        var error: NSError?

        guard context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) else {
            return debugPrint(error?.localizedDescription ?? "")
        }

        let reason = "Face ID authentication"
        context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { isAuthorized, error in
            guard isAuthorized else {
                return debugPrint(error?.localizedDescription ?? "")
            }
            DispatchQueue.main.async {
                super.transitionToMain()
            }
        }
    }

    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 1 {
            return context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil) ? 2 : 1
        } else {
            return super.tableView(tableView, numberOfRowsInSection: section)
        }
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
