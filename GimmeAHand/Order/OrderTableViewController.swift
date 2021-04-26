//
//  OrderTableViewController.swift
//  GimmeAHand
//
//  Created by Kuixi Song on 3/15/21.
//

import UIKit
import DZNEmptyDataSet

class OrderTableViewController: GHFilterViewTableViewController {

    var currentType: GHOrderSelectionType = .placed
    var modelArray: [OrderModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Orders \(GHOrderSelectionType.placed.description)"
        
        // Make sure that there is a path top to bottom, that can determine the height of current cell
        tableView.rowHeight = UITableView.automaticDimension
        tableView.register(UINib(nibName: "OrderTableViewCell", bundle: nil),
                           forCellReuseIdentifier: OrderTableViewCell.reuseIdentifier)
        tableView.emptyDataSetSource = self
        tableView.emptyDataSetDelegate = self
        
        // Add a UISegmentedControl to choose between placed and taken orders
        let segmentedControl = UISegmentedControl(items: GHOrderSelectionType.allCases.map { $0.description })
        segmentedControl.frame = CGRect(x: 0, y: 0, width: 300.0, height: segmentedControl.frame.height)
        segmentedControl.selectedSegmentIndex = 0
        navigationItem.titleView = segmentedControl
        segmentedControl.addTarget(self, action: #selector(segmentValueChanged), for: .valueChanged)
        
        // Register notifications
        NotificationCenter.default.addObserver(self, selector: #selector(reloadOrders), name: .GHRefreshMyOrders, object: nil)
        
        reloadOrders()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: .GHRefreshMyOrders, object: nil)
    }
    
    @objc func reloadOrders() {
        switch currentType {
        case .placed:
            modelArray = OrderHelper.shared.getOrderList().filter {
                $0.creator == UserHelper.shared.currentUser
            }
        case .taken:
            modelArray = OrderHelper.shared.getOrderList().filter {
                $0.courier != nil && $0.courier! == UserHelper.shared.currentUser
            }
        }
        tableView.reloadData()
    }
    
    @objc func segmentValueChanged(_ sender: UISegmentedControl) {
        navigationItem.title = "Orders \(sender.titleForSegment(at: sender.selectedSegmentIndex) ?? "")"
        currentType = GHOrderSelectionType(rawValue: sender.selectedSegmentIndex)!
        reloadOrders()
    }
    
    @IBAction func infoAction(_ sender: UIBarButtonItem) {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 10.0
        stackView.alignment = .fill
        stackView.distribution = .fillProportionally
        let label = UILabel(frame: CGRect(origin: .zero, size: CGSize(width: view.frame.width, height: 20.0)))
        label.text = "The status of an order means this order..."
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.textColor = .secondaryLabel
        stackView.addArrangedSubview(label)
        let subStackView = UIStackView()
        subStackView.axis = .vertical
        subStackView.alignment = .fill
        subStackView.distribution = .fillEqually
        subStackView.spacing = 10.0
        for status in GHOrderStatus.allCases {
            let label = UILabel()
            label.text = "\(status.rawValue): \(status.description)"
            label.textColor = status.color
            label.numberOfLines = 0
            subStackView.addArrangedSubview(label)
        }
        stackView.addArrangedSubview(subStackView)
        showFilterView("Order Status Info", stackView)
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return modelArray.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: OrderTableViewCell.reuseIdentifier, for: indexPath) as! OrderTableViewCell

        // Configure the cell...
        cell.config(modelArray[indexPath.row])

        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        // navigate to order detail view controller
        performSegue(withIdentifier: "orderDetailSegue", sender: modelArray[indexPath.row])
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == "orderDetailSegue" {
            guard let model = sender as? OrderModel else {
                return
            }
            let destinationViewController = segue.destination as! OrderDetailTableViewController
            destinationViewController.orderModel = model
            destinationViewController.isFromHomepage = false
        }
    }

}

extension OrderTableViewController: DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {
    
    func emptyDataSetShouldDisplay(_ scrollView: UIScrollView) -> Bool {
        return modelArray.isEmpty
    }
    
    func title(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
        return NSAttributedString(string: "No result")
    }
    
}
