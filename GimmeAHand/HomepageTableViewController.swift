//
//  HomepageTableViewController.swift
//  GimmeAHand
//
//  Created by Kuixi Song on 3/20/21.
//

import UIKit
import RangeSeekSlider

class HomepageTableViewController: UITableViewController {

    var modelArray: [OrderModel] = []
    
    var selectedCategories = Set<String>(GHOrderCategory.allCases.map { $0.rawValue })
    var selectAmountRange: (CGFloat, CGFloat) = (0.0, 10.0)
    var selectDistanceRange: (CGFloat, CGFloat) = (0.0, 50.0)
    
    // views for filter display
    
    lazy var containerView: UIView = {
        let containerView = UIView(frame: CGRect(x: 0.0, y: self.tableView.frame.height, width: self.tableView.frame.width, height: 350.0))
        containerView.backgroundColor = .systemBackground
        containerView.setRoundCorner(20.0)
        return containerView
    }()
    lazy var blurEffectView: UIVisualEffectView = {
        let blurEffectView = UIVisualEffectView()
        blurEffectView.frame = view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        blurEffectView.isUserInteractionEnabled = true
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissFilterView))
        blurEffectView.addGestureRecognizer(tapGesture)
        
        return blurEffectView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.register(UINib(nibName: "OrderTableViewCell", bundle: nil),
                           forCellReuseIdentifier: OrderTableViewCell.reuseIdentifier)
        
        // pull to refresh
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshAction), for: .valueChanged)
        tableView.refreshControl = refreshControl
        
        // table view header
        let containerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 70.0))
        let stackView = UIStackView(frame: CGRect(x: 18.0, y: 10.0, width: containerView.frame.width - 36.0, height: 40.0))
        for (idx, title) in ["Category", "Money", "Distance"].enumerated() {
            let button = UIButton(frame: CGRect(x: 0, y: 0, width: stackView.frame.width / 3.0, height: stackView.frame.height))
            button.setTitle(title, for: .normal)
            button.setTitleColor(.white, for: .normal)
            button.backgroundColor = .link
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
                                      status: .created,
                                      date: Date(),
                                      category: GHOrderCategory.allCases.randomElement()!,
                                      community: navigationItem.title ?? "None")
            modelArray.append(newOrder)
        }
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
        let communityViewController = CommunitySearchTableViewController.embeddedInNavigationController(self)
        present(communityViewController, animated: true)
    }
    
    // filter actions and helper functions
    
    @objc func filterAction(_ sender: UIButton) {
        switch sender.tag {
        case 0:
            let updateButtonColor = { (button: UIButton, selected: Bool) in
                if selected {
                    button.backgroundColor = .link
                    button.setTitleColor(.white, for: .normal)
                    button.tintColor = .white
                } else {
                    button.backgroundColor = .systemBackground
                    button.setTitleColor(.link, for: .normal)
                    button.tintColor = .link
                }
            }
            
            let allCategories = GHOrderCategory.allCases
            let bigStackView = UIStackView()
            bigStackView.axis = .vertical
            bigStackView.spacing = 10.0
            bigStackView.alignment = .fill
            bigStackView.distribution = .fillEqually
            for i in 0...2 {
                let smallStackView = UIStackView()
                smallStackView.axis = .horizontal
                smallStackView.spacing = 10.0
                for j in 0...1 {
                    let currentCategory = allCategories[i * 2 + j]
                    let currentCategoryString = currentCategory.rawValue
                    let currentCategoryImage = currentCategory.getImage()
                    let button = UIButton()
                    button.setTitle(currentCategoryString, for: .normal)
                    button.setImage(currentCategoryImage, for: .normal)
                    button.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 10.0);
                    button.setRoundCorner()
                    updateButtonColor(button, selectedCategories.contains(currentCategoryString))
                    button.addAction(UIAction(handler: { [weak self] (action) in
                        guard let strongSelf = self else {
                            return
                        }
                        UIView.animate(withDuration: 0.1) {
                            if strongSelf.selectedCategories.contains(currentCategoryString) {
                                strongSelf.selectedCategories.remove(currentCategoryString)
                                updateButtonColor(button, false)
                            } else {
                                strongSelf.selectedCategories.insert(currentCategoryString)
                                updateButtonColor(button, true)
                            }
                        }
                    }), for: .touchUpInside)
                    smallStackView.addArrangedSubview(button)
                }
                smallStackView.alignment = .fill
                smallStackView.distribution = .fillEqually
                bigStackView.addArrangedSubview(smallStackView)
            }
            showFilterView("Select Categories", bigStackView)
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
            showFilterView("Set Amount Range", rangeSlider)
        case 2:
            let rangeSlider = RangeSeekSlider()
            rangeSlider.setupGHStyle()
            rangeSlider.numberFormatter = GHConstant.kDistanceFormatter
            rangeSlider.selectedMinValue = selectDistanceRange.0
            rangeSlider.selectedMaxValue = selectDistanceRange.1
            rangeSlider.minValue = 0.0
            rangeSlider.maxValue = 50.0
            rangeSlider.tag = RangeSliderTag.distance.rawValue
            rangeSlider.delegate = self
            showFilterView("Set Distance Range", rangeSlider)
        default:
            break
        }
    }
    
    func showFilterView(_ filterTitle: String, _ filterView: UIView) {
        let margin: CGFloat = 20.0
        
        // clear old subviews
        containerView.subviews.forEach {
            $0.removeFromSuperview()
        }
        
        UIView.animate(withDuration: GHConstant.kFilterViewTransitionDuration, delay: 0.0, options: [.curveEaseOut, .transitionFlipFromBottom]) {
            
            // execute animation
            self.blurEffectView.effect = UIBlurEffect(style: .dark)
            UIApplication.shared.windows.first!.addSubview(self.blurEffectView)
            let containerView = self.containerView
            
            // real animation
            containerView.frame.origin.y = self.tableView.frame.height - containerView.frame.height
            
            // add title
            let titleLabel = UILabel(frame: CGRect(x: margin, y: 0, width: containerView.frame.width - 2 * margin, height: 80.0))
            titleLabel.font = UIFont.boldSystemFont(ofSize: 34.0)
            titleLabel.text = filterTitle
            containerView.addSubview(titleLabel)
            
            // add dismiss button
            let dismissButton = UIButton(frame: CGRect(x: margin, y: containerView.frame.height - 80.0, width: containerView.frame.width - 2 * margin, height: 40.0))
            dismissButton.backgroundColor = .link
            dismissButton.setRoundCorner()
            dismissButton.setTitle("OK", for: .normal)
            dismissButton.titleLabel?.font = UIFont.preferredFont(forTextStyle: .headline)
            dismissButton.addAction(UIAction(handler: { (action) in
                // dismiss the containerView
                self.dismissFilterView(nil)
            }), for: .touchUpInside)
            containerView.addSubview(dismissButton)
            
            // add customzied filter view
            filterView.translatesAutoresizingMaskIntoConstraints = false
            containerView.addSubview(filterView)
            containerView.addConstraints([
                NSLayoutConstraint(item: filterView, attribute: .top, relatedBy: .equal, toItem: titleLabel, attribute: .bottom, multiplier: 1.0, constant: 0.0),
                NSLayoutConstraint(item: filterView, attribute: .bottom, relatedBy: .equal, toItem: dismissButton, attribute: .top, multiplier: 1.0, constant: -margin),
                NSLayoutConstraint(item: filterView, attribute: .leading, relatedBy: .equal, toItem: containerView, attribute: .leading, multiplier: 1.0, constant: margin),
                NSLayoutConstraint(item: filterView, attribute: .trailing, relatedBy: .equal, toItem: containerView, attribute: .trailing, multiplier: 1.0, constant: -margin)
            ])
            containerView.updateConstraintsIfNeeded()
            
            UIApplication.shared.windows.first!.addSubview(containerView)
            UIApplication.shared.windows.first!.bringSubviewToFront(containerView)
        } completion: { (completed) in
            if completed {
                self.tableView.isUserInteractionEnabled = false
            }
        }
    }
    
    @objc func dismissFilterView(_ sender: UITapGestureRecognizer?) {
        UIView.animate(withDuration: GHConstant.kFilterViewTransitionDuration, delay: 0.0, options: .curveEaseIn) {
            // dismiss containerview animation
            self.blurEffectView.effect = nil
            self.containerView.frame.origin.y = self.tableView.frame.height
        } completion: { (completed) in
            if completed {
                self.containerView.removeFromSuperview()
                self.blurEffectView.removeFromSuperview()
                self.tableView.isUserInteractionEnabled = true
            }
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
        navigationItem.title = community
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
