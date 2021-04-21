//
//  HomepageTableViewController.swift
//  GimmeAHand
//
//  Created by Kuixi Song on 3/20/21.
//

import UIKit
import CoreLocation
import DZNEmptyDataSet
import SVProgressHUD

typealias RangePair = (CGFloat, CGFloat)

class HomepageTableViewController: GHFilterViewTableViewController {
    
    let locationManager = MapHelper.shared.locationManager
    var currentLocation: CLLocation? = nil
    
    var originalModelArray: [OrderModel] = []
    var modelArray: [OrderModel] = []
    
    var selectedCommunity: CommunityModel? {
        didSet {
            navigationItem.title = "Orders in \(selectedCommunity?.name ?? "")"
            filterOrders()
        }
    }
    var selectedCategories = Set<String>(GHOrderCategory.allCases.map { $0.rawValue }) {
        didSet {
            filterOrders()
        }
    }
    var selectAmountRange: RangePair = (0.0, 10.0) {
        didSet {
            filterOrders()
        }
    }
    var selectDistanceRange: RangePair = (0.0, 10.0) {
        didSet {
            filterOrders()
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
        
        // location manager
        locationManager.startUpdatingLocation()
        locationManager.delegate = self
        locationManager.requestLocation()
        
        // notifications
        NotificationCenter.default.addObserver(self, selector: #selector(reloadOrders), name: .GHRefreshHomepage, object: nil)
        
        // reload orders
        reloadOrders()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: .GHRefreshHomepage, object: nil)
    }
    
    @objc func reloadOrders() {
        originalModelArray = OrderHelper.shared.getOrderList().filter { $0.status == .submitted }
        filterOrders()
    }
    
    func filterOrders() {
        modelArray = originalModelArray
        
        if let selectCommunity = selectedCommunity {
            modelArray = modelArray.filter { $0.community == selectCommunity }
        }
        modelArray = modelArray.filter { selectedCategories.contains($0.category.rawValue) }
        modelArray = modelArray.filter({ (model) -> Bool in
            return Double(selectAmountRange.0) <= model.amount && model.amount <= Double(selectAmountRange.1)
        })
        if let currentLocation = currentLocation {
        modelArray = modelArray.filter({ (model) -> Bool in
            let distance = model.community.distanceFromLocation(currentLocation)
            return Double(selectDistanceRange.0) <= distance && distance <= Double(selectDistanceRange.1)
        })
        }
        
        tableView.reloadData()
    }
    
    @objc func refreshAction(_ sender: UIRefreshControl) {
        if sender.isRefreshing {
            // TODO: pull latest data
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2)) { [weak self] in
                guard let strongSelf = self else {
                    return
                }
                strongSelf.reloadOrders()
                sender.endRefreshing()
            }
        }
    }
    
    @IBAction func communityAction(_ sender: UIBarButtonItem) {
        let communityViewController = CommunitySearchTableViewController.embeddedInNavigationController(self, .filter)
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

        cell.config(modelArray[indexPath.row], true, currentLocation)

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
    
    func didSelectCommunity(_ community: CommunityModel) {
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

extension HomepageTableViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else {
            debugPrint("No Locations found")
            return
        }
        currentLocation = location
        filterOrders()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        SVProgressHUD.showError(withStatus: error.localizedDescription)
    }
    
}

