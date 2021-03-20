//
//  HomepageTableViewController.swift
//  GimmeAHand
//
//  Created by Kuixi Song on 3/20/21.
//

import UIKit

class HomepageTableViewController: UITableViewController {

    var modelArray: [OrderModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Make sure that there is a path top to bottom, that can determine the height of current cell
        tableView.rowHeight = UITableView.automaticDimension
        tableView.register(UINib(nibName: "OrderTableViewCell", bundle: nil),
                           forCellReuseIdentifier: OrderTableViewCell.reuseIdentifier)
        
        for i in 0..<20 {
            let newOrder = OrderModel(id: i,
                                      name: "Order \(i)",
                                      description: "blahblahblah",
                                      amount: Float.random(in: 0..<10),
                                      status: GHOrderStatus.allCases.randomElement()!,
                                      date: Date(),
                                      category: GHOrderCategory.allCases.randomElement()!)
            modelArray.append(newOrder)
        }
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
        }
    }

}
