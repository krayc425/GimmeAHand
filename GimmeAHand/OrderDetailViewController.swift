//
//  OrderDetailViewController.swift
//  GimmeAHand
//
//  Created by Kuixi Song on 3/15/21.
//

import UIKit

class OrderDetailViewController: UIViewController {

    @IBOutlet weak var informationLabel: UILabel!
    
    var orderModel: OrderModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        guard let model = orderModel else {
            return
        }
        informationLabel.text = "\(model.name)\n\(model.orderDescription)"
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
