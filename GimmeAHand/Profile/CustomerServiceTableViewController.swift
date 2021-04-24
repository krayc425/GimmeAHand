//
//  CustomerServiceTableViewController.swift
//  GimmeAHand
//
//  Created by Kuixi Song on 4/24/21.
//

import UIKit
import SVProgressHUD

class CustomerServiceTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func submitAction(_ sender: UIButton) {
        SVProgressHUD.show(withStatus: "Submitting Request")
        SVProgressHUD.dismiss(withDelay: GHConstant.kHUDDuration) { [weak self] in
            guard let strongSelf = self else {
                return
            }
            strongSelf.navigationController?.dismiss(animated: true)
        }
    }

    // MARK: - Table view data source

}
