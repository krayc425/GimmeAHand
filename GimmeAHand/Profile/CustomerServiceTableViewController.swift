//
//  CustomerServiceTableViewController.swift
//  GimmeAHand
//
//  Created by Kuixi Song on 4/24/21.
//

import UIKit
import SVProgressHUD

class CustomerServiceTableViewController: UITableViewController {

    private static let selectionSection = 1
    
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var submitButton: UIButton!
    
    var selectedIndexPath: IndexPath? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        descriptionTextView.delegate = self
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 44.0
    }
    
    @IBAction func dismissAction(_ sender: UIBarButtonItem) {
        navigationController?.dismiss(animated: true)
    }
    
    @IBAction func submitAction(_ sender: UIButton) {
        // Validation
        guard let _ = selectedIndexPath else {
            SVProgressHUD.showInfo(withStatus: "Select a category for your problem")
            return
        }
        guard !descriptionTextView.text.isEmpty else {
            SVProgressHUD.showInfo(withStatus: "Please provide detailed descriptions")
            descriptionTextView.becomeFirstResponder()
            return
        }
        
        SVProgressHUD.show(withStatus: "Submitting Request")
        SVProgressHUD.dismiss(withDelay: GHConstant.kHUDDuration) { [weak self] in
            guard let strongSelf = self else {
                return
            }
            strongSelf.navigationController?.dismiss(animated: true)
        }
    }

    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == CustomerServiceTableViewController.selectionSection {
            let cell = super.tableView(tableView, cellForRowAt: indexPath)
            if let selectedIndexPath = selectedIndexPath, selectedIndexPath == indexPath {
                cell.accessoryType = .checkmark
            } else {
                cell.accessoryType = .none
            }
            return cell
        } else {
            return super.tableView(tableView, cellForRowAt: indexPath)
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.section == CustomerServiceTableViewController.selectionSection {
            selectedIndexPath = indexPath
        }
        tableView.reloadData()
    }

}

extension CustomerServiceTableViewController: UITextViewDelegate {
    
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
