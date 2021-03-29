//
//  PaymentTableViewController.swift
//  GimmeAHand
//
//  Created by Kuixi Song on 3/23/21.
//

import UIKit

protocol PaymentTableViewControllerDelegate {
    
    func didSelectPayment(_ payment: String)
    
}

class PaymentTableViewController: UITableViewController {
    
    static func embeddedInNavigationController(_ parent: PaymentTableViewControllerDelegate?) -> UINavigationController {
        let paymentTableViewController = PaymentTableViewController()
        paymentTableViewController.delegate = parent
        let navigationController = UINavigationController(rootViewController: paymentTableViewController)
        navigationController.navigationBar.prefersLargeTitles = true
        navigationController.navigationItem.largeTitleDisplayMode = .always
        return navigationController
    }
    
    let paymentTypes = GHPaymentType.allCases
    
    var delegate: PaymentTableViewControllerDelegate? = nil
    var selectedPaymentIndexPath: IndexPath? {
        didSet {
            navigationItem.rightBarButtonItem?.isEnabled = selectedPaymentIndexPath != nil
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Payment Method"
        
        let backBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(dismissAction))
        navigationItem.leftBarButtonItem = backBarButtonItem
        let doneBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneAction))
        navigationItem.rightBarButtonItem = doneBarButtonItem
        doneBarButtonItem.isEnabled = false
        
        tableView.register(UINib(nibName: "PaymentTableViewCell", bundle: nil), forCellReuseIdentifier: PaymentTableViewCell.reuseIdentifier)
        tableView.tableFooterView = UIView()
    }
    
    @objc func dismissAction(_ sender: UIBarButtonItem) {
        navigationController?.dismiss(animated: true)
    }
    
    @objc func doneAction(_ sender: UIBarButtonItem) {
        navigationController?.dismiss(animated: true) { [weak self] in
            guard let strongSelf = self,
                  let selectedIndexPath = strongSelf.selectedPaymentIndexPath else {
                return
            }
            strongSelf.delegate?.didSelectPayment(strongSelf.paymentTypes[selectedIndexPath.row].rawValue)
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return paymentTypes.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: PaymentTableViewCell.reuseIdentifier, for: indexPath) as! PaymentTableViewCell
        
        cell.config(paymentTypes[indexPath.row])
        
        if let selectedIndexPath = selectedPaymentIndexPath, selectedIndexPath == indexPath {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }

        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if let selectedIndexPath = selectedPaymentIndexPath, selectedIndexPath == indexPath {
            selectedPaymentIndexPath = nil
        } else {
            selectedPaymentIndexPath = indexPath
        }
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44.0
    }

}
