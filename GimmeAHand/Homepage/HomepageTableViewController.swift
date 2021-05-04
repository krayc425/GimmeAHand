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

class HomepageTableViewController: GHFilterViewTableViewController {
    
    @IBOutlet weak var communityBarButtonItem: UIBarButtonItem!
    
    let locationManager = MapHelper.shared.locationManager
    var currentLocation: CLLocation? = nil
    
    var originalModelArray: [OrderModel] = []
    var modelArray: [OrderModel] = []
    
    var selectedCommunity: CommunityModel? {
        didSet {
            communityBarButtonItem.title = selectedCommunity?.name ?? "All Communities"
            filterAndSortOrders()
        }
    }
    var selectedCategories = Set<String>(GHOrderCategory.allCases.map { $0.rawValue }) {
        didSet {
            filterAndSortOrders()
        }
    }
    var selectAmountRange: RangePair = (0.0, 10.0) {
        didSet {
            filterAndSortOrders()
        }
    }
    var selectDistanceRange: RangePair = (0.0, 10.0) {
        didSet {
            filterAndSortOrders()
        }
    }
    var selectedSortMethod: GHOrderSortMethod = .latest {
        didSet {
            filterAndSortOrders()
        }
    }
    
    lazy var sortButtons: [GHSortButton] = {
        guard let currentLocation = currentLocation else {
            SVProgressHUD.showInfo(withStatus: "Waiting to determine your location")
            return []
        }
        let allMethods: [GHOrderSortMethod] = [.latest, .expireSoon, .highestTips, .nearest(currentLocation)]
        var buttons: [GHSortButton] = []
        for method in allMethods {
            let button = GHSortButton(method)
            button.setTitle(method.description, for: .normal)
            button.setRoundCorner()
            buttons.append(button)
        }
        return buttons
    }()
    
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
        for (idx, title) in ["Filter Orders", "Sort Orders"].enumerated() {
            let button = UIButton(frame: CGRect(x: 0, y: 0, width: stackView.frame.width / 2.0, height: stackView.frame.height))
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
        NotificationCenter.default.addObserver(self, selector: #selector(viewOrderDetail(_:)), name: .GHHomepageToDetail, object: nil)
        
        // reload orders
        reloadOrders()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: .GHRefreshHomepage, object: nil)
        NotificationCenter.default.removeObserver(self, name: .GHHomepageToDetail, object: nil)
    }
    
    @objc func reloadOrders() {
        originalModelArray = OrderHelper.shared.getOrderList().filter { $0.status == .submitted }
        filterAndSortOrders()
    }
    
    @objc func viewOrderDetail(_ notification: Notification) {
        guard let order = notification.userInfo?["order"] else {
            return
        }
        performSegue(withIdentifier: "orderDetailSegue", sender: order)
    }
    
    func filterAndSortOrders() {
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
            let distance = model.destinationDistanceFromLocation(currentLocation)
            return Double(selectDistanceRange.0) <= distance && distance <= Double(selectDistanceRange.1)
        })
        }
        
        modelArray.sort(by: selectedSortMethod.handler)
        
        tableView.reloadData()
    }
    
    @objc func refreshAction(_ sender: UIRefreshControl) {
        if sender.isRefreshing {
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
            let stackView = UIStackView()
            stackView.axis = .vertical
            stackView.distribution = .fillProportionally
            stackView.alignment = .fill
            
            let categorySelectionView = GHCategorySelectionView(selectedCategories) { [weak self] action in
                guard let strongSelf = self,
                      let button = action.sender as? UIButton,
                      let currentCategoryString = button.title(for: .normal) else {
                    return
                }
                UIView.animate(withDuration: GHConstant.kFilterViewAnimationDuration) {
                    if strongSelf.selectedCategories.contains(currentCategoryString) {
                        strongSelf.selectedCategories.remove(currentCategoryString)
                        button.updateSelectionColor(selected: false)
                    } else {
                        strongSelf.selectedCategories.insert(currentCategoryString)
                        button.updateSelectionColor(selected: true)
                    }
                }
            }
            stackView.addArrangedSubview(categorySelectionView)
            
            let rangeSlider1 = RangeSeekSlider()
            rangeSlider1.setupGHStyle()
            rangeSlider1.numberFormatter = GHConstant.kAmountFormatter
            rangeSlider1.selectedMinValue = selectAmountRange.0
            rangeSlider1.selectedMaxValue = selectAmountRange.1
            rangeSlider1.minValue = 0.0
            rangeSlider1.maxValue = 10.0
            rangeSlider1.tag = GHRangeSliderTag.amount.rawValue
            rangeSlider1.delegate = self
            stackView.addArrangedSubview(rangeSlider1)
            
            let rangeSlider2 = RangeSeekSlider()
            rangeSlider2.setupGHStyle()
            rangeSlider2.numberFormatter = GHConstant.kDistanceFormatter
            rangeSlider2.selectedMinValue = selectDistanceRange.0
            rangeSlider2.selectedMaxValue = selectDistanceRange.1
            rangeSlider2.minValue = 0.0
            rangeSlider2.maxValue = 10.0
            rangeSlider2.tag = GHRangeSliderTag.distance.rawValue
            rangeSlider2.delegate = self
            stackView.addArrangedSubview(rangeSlider2)
            
            showFilterView("Filter Orders", stackView)
        case 1:
            let stackView = UIStackView()
            stackView.axis = .vertical
            stackView.distribution = .fillEqually
            stackView.alignment = .fill
            stackView.spacing = 20.0
            
            for button in sortButtons {
                button.updateSelectionColor(selected: button.sortMethod == selectedSortMethod)
                button.addAction(UIAction(handler: { [weak self] _ in
                    guard let strongSelf = self else {
                        return
                    }
                    strongSelf.selectedSortMethod = button.sortMethod
                    UIView.animate(withDuration: GHConstant.kFilterViewAnimationDuration) {
                        for btn in strongSelf.sortButtons {
                            btn.updateSelectionColor(selected: btn.sortMethod == strongSelf.selectedSortMethod)
                        }
                    }
                }) , for: .touchUpInside)
                stackView.addArrangedSubview(button)
            }
            
            showFilterView("Sort Orders", stackView)
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

        cell.config(modelArray[indexPath.row], currentLocation)

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
    }
    
    func didSelectAllCommunities() {
        selectedCommunity = nil
    }
    
}

extension HomepageTableViewController: RangeSeekSliderDelegate {
    
    func rangeSeekSlider(_ slider: RangeSeekSlider, didChange minValue: CGFloat, maxValue: CGFloat) {
        switch GHRangeSliderTag(rawValue: slider.tag) {
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
        return NSAttributedString(string: "No result")
    }
    
}

extension HomepageTableViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else {
            SVProgressHUD.showError(withStatus: "No locations found")
            return
        }
        currentLocation = location
        filterAndSortOrders()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        SVProgressHUD.showError(withStatus: error.localizedDescription)
    }
    
}
