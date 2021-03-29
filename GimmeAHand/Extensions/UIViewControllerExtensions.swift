//
//  UIViewControllerExtensions.swift
//  GimmeAHand
//
//  Created by Kuixi Song on 3/28/21.
//

import UIKit

extension UIViewController {
    
    func simpleAlert(_ title: String, _ msg: String? = nil, _ completion: (() -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true, completion: completion)
    }
    
}
