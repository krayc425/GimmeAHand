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
    @IBOutlet weak var bioTypeLabel: UILabel!
    
    let userDefaultsHelper = UserDefaultsHelper.shared
    let context = LAContext()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        faceIDSwitch.isOn = userDefaultsHelper.getFaceID()
        rememberMeSwitch.isOn = userDefaultsHelper.getRememberMe()
        [faceIDSwitch, rememberMeSwitch].forEach {
            $0?.addTarget(self, action: #selector(switchAction), for: .valueChanged)
        }
        
        [emailTextField, passwordTextField].forEach {
            $0?.delegate = self
        }
        
        _ = context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil)
        bioTypeLabel.text = context.biometryType == .faceID ? "Face ID" : "Touch ID"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        emailTextField.text = userDefaultsHelper.getEmail()
    }
    
    @objc func switchAction(_ sender: UISwitch) {
        switch sender {
        case faceIDSwitch:
            userDefaultsHelper.saveFaceID(faceIDSwitch.isOn)
        case rememberMeSwitch:
            userDefaultsHelper.saveRememberMe(rememberMeSwitch.isOn)
        default:
            break
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
        guard let email = emailTextField.text, !email.isEmpty else {
            simpleAlert("Please enter email", nil) { [weak self] in
                self?.emailTextField.becomeFirstResponder()
            }
            return
        }
        guard let password = passwordTextField.text, !password.isEmpty else {
            simpleAlert("Please enter password", nil) { [weak self] in
                self?.passwordTextField.becomeFirstResponder()
            }
            return
        }
        if rememberMeSwitch.isOn {
            userDefaultsHelper.saveEmail(email)
        }
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
        guard context.canEvaluatePolicy(.deviceOwnerAuthentication, error: nil) else {
            return
        }

        let reason = "Face ID authentication"
        context.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: reason) { isAuthorized, error in
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
        switch textField {
        case emailTextField:
            emailTextField.resignFirstResponder()
            passwordTextField.becomeFirstResponder()
        case passwordTextField:
            passwordTextField.resignFirstResponder()
            login()
        default:
            break
        }
        return true
    }
    
}
