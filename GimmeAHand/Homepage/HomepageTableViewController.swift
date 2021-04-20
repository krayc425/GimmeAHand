//
//  HomepageTableViewController.swift
//  GimmeAHand
//
//  Created by Kuixi Song on 3/20/21.
//

import UIKit
import DZNEmptyDataSet

typealias RangePair = (CGFloat, CGFloat)

class HomepageTableViewController: GHFilterViewTableViewController {

    var originalModelArray: [OrderModel] = []
    var modelArray: [OrderModel] = []
    
    var selectedCommunity: String? {
        didSet {
            navigationItem.title = "Orders in \(selectedCommunity ?? "")"
            reloadOrders()
        }
    }
    var selectedCategories = Set<String>(GHOrderCategory.allCases.map { $0.rawValue }) {
        didSet {
            reloadOrders()
        }
    }
    var selectAmountRange: RangePair = (0.0, 10.0) {
        didSet {
            reloadOrders()
        }
    }
    var selectDistanceRange: RangePair = (0.0, 10.0) {
        didSet {
            reloadOrders()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.register(UINib(nibName: "OrderTableViewCell", bundle: nil),
                           forCellReuseIdentifier: OrderTableViewCell.reuseIdentifier)
        tableView.emptyDataSetSource = self
        tableView.emptyDataSetDelegate = self
        
        // pull to refresh
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshAction), for: .valueChanged)
        tableView.refreshControl = refreshControl
        
        // table view header
        let containerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 70.0))
        let stackView = UIStackView(frame: CGRect(x: 18.0, y: 10.0, width: containerView.frame.width - 36.0, height: 40.0))
        for (idx, title) in ["Categories", "Amount", "Distance"].enumerated() {
            let button = UIButton(frame: CGRect(x: 0, y: 0, width: stackView.frame.width / 3.0, height: stackView.frame.height))
            button.setTitle(title, for: .normal)
            button.setTitleColor(.white, for: .normal)
            button.backgroundColor = .GHTint
            button.titleLabel?.font = UIFont.boldSystemFont(ofSize: UIFont.systemFontSize)
            button.setRoundCorner()
            button.tag = idx
            button.addTarget(self, action: #selector(filterAction), for: .touchUpInside)
            stackView.addArrangedSubview(button)
        }
        stackView.spacing = 10.0
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        containerView.addSubview(stackView)
        tableView.tableHeaderView = containerView
        
        for i in 0..<20 {
            let newOrder = OrderModel(id: i,
                                      name: "Order \(i)",
                                      description: "blahblahblah",
                                      amount: Float.random(in: 0..<10),
                                      status: .submitted,
                                      createDate: Date(),
                                      startDate: Date(),
                                      endDate: Date(),
                                      category: GHOrderCategory.allCases.randomElement()!,
                                      community: ["CMU Pittsburgh", "CMU SV", "Kenmwar Apartment", "Avalon Mountain View"].randomElement()!)
            originalModelArray.append(newOrder)
        }
        
        reloadOrders()
    }
    
    func reloadOrders() {
        modelArray.removeAll()
        modelArray.append(contentsOf: originalModelArray)
        
        if let selectCommunity = selectedCommunity {
            modelArray = modelArray.filter { $0.community == selectCommunity }
        }
        modelArray = modelArray.filter { selectedCategories.contains($0.category.rawValue) }
        modelArray = modelArray.filter({ (model) -> Bool in
            return Float(selectAmountRange.0) <= model.amount && model.amount <= Float(selectAmountRange.1)
        })
        
        tableView.reloadData()
    }
    
    @objc func refreshAction(_ sender: UIRefreshControl) {
        if sender.isRefreshing {
            // TODO: pull latest data
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2)) {
                sender.endRefreshing()
            }
        }
    }
    
    @IBAction func communityAction(_ sender: UIBarButtonItem) {
        let communityViewController = CommunitySearchTableViewController.embeddedInNavigationController(self, "Filter by Community")
        present(communityViewController, animated: true)
    }
    
    // filter actions and helper functions
    
    @objc func filterAction(_ sender: UIButton) {
        switch sender.tag {
        case 0:
            let categorySelectionView = GHCategorySelectionView(selectedCategories) { [weak self] action in
                guard let strongSelf = self,
                      let button = action.sender as? UIButton,
                      let currentCategoryString = button.title(for: .normal) else {
                    return
                }
                UIView.animate(withDuration: 0.1) {
                    if strongSelf.selectedCategories.contains(currentCategoryString) {
                        strongSelf.selectedCategories.remove(currentCategoryString)
                        button.updateSelectionColor(selected: false)
                    } else {
                        strongSelf.selectedCategories.insert(currentCategoryString)
                        button.updateSelectionColor(selected: true)
                    }
                }
            }
            showFilterView("Filter by Categories", categorySelectionView)
        case 1:
            let rangeSlider = RangeSeekSlider()
            rangeSlider.setupGHStyle()
            rangeSlider.numberFormatter = GHConstant.kAmountFormatter
            rangeSlider.selectedMinValue = selectAmountRange.0
            rangeSlider.selectedMaxValue = selectAmountRange.1
            rangeSlider.minValue = 0.0
            rangeSlider.maxValue = 10.0
            rangeSlider.tag = RangeSliderTag.amount.rawValue
            rangeSlider.delegate = self
            showFilterView("Filter by Amount", rangeSlider)
        case 2:
            let rangeSlider = RangeSeekSlider()
            rangeSlider.setupGHStyle()
            rangeSlider.numberFormatter = GHConstant.kDistanceFormatter
            rangeSlider.selectedMinValue = selectDistanceRange.0
            rangeSlider.selectedMaxValue = selectDistanceRange.1
            rangeSlider.minValue = 0.0
            rangeSlider.maxValue = 10.0
            rangeSlider.tag = RangeSliderTag.distance.rawValue
            rangeSlider.delegate = self
            showFilterView("Filter by Distance", rangeSlider)
        default:
            break
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

        cell.config(modelArray[indexPath.row], true)

        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        performSegue(withIdentifier: "orderDetailSegue", sender: modelArray[indexPath.row])
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "orderDetailSegue" {
            guard let model = sender as? OrderModel else {
                return
            }
            let destinationViewController = segue.destination as! OrderDetailTableViewController
            destinationViewController.orderModel = model
            destinationViewController.isFromHomepage = true
        }
    }

}

extension HomepageTableViewController: CommunitySearchTableViewControllerDelegate {
    
    func didSelectCommunity(_ community: String) {
        selectedCommunity = community
        // TODO: load orders based on the community
    }
    
}

extension HomepageTableViewController: RangeSeekSliderDelegate {
    
    func rangeSeekSlider(_ slider: RangeSeekSlider, didChange minValue: CGFloat, maxValue: CGFloat) {
        switch RangeSliderTag(rawValue: slider.tag) {
        case .amount:
            selectAmountRange = (minValue, maxValue)
        case .distance:
            selectDistanceRange = (minValue, maxValue)
        default:
            break
        }
    }
    
}

extension HomepageTableViewController: DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {
    
    func emptyDataSetShouldDisplay(_ scrollView: UIScrollView) -> Bool {
        return modelArray.isEmpty
    }
    
    func title(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
        return NSAttributedString(string: "Empty result")
    }
    
}
