//
//  AuthenticateTableViewController.swift
//  GimmeAHand
//
//  Created by Kuixi Song on 3/20/21.
//

import UIKit

class AuthenticateTableViewController: UITableViewController {
    
    func transitionToMain() {
        UIView.transition(with: UIApplication.shared.windows.first!,
                          duration: GHConstant.kStoryboardTransitionDuration,
                          options: .transitionFlipFromLeft,
                          animations: {
                            UIApplication.shared.windows.first!.rootViewController = UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController()
        })
    }
    
}
