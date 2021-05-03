//
//  ProfileTableViewController.swift
//  GimmeAHand
//
//  Created by Yifan Huang on 3/20/21.
//

import UIKit
import CoreLocation
import SVProgressHUD

class ProfileTableViewController: UITableViewController {
    
    @IBOutlet weak var addCommunityButton: UIButton!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var logoutBotton: UIButton!
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var emailVerifyLabel: UILabel!
    @IBOutlet weak var phoneVerifyLabel: UILabel!
    @IBOutlet weak var statisticsLabel: UILabel!
    
    let locationManager = MapHelper.shared.locationManager
    
    var selectedCommunities: [CommunityModel] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 44.0
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "ProfileCommunityTableViewCell")
        
        locationManager.startUpdatingLocation()
        locationManager.delegate = self
        locationManager.requestLocation()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let currentUser = UserHelper.shared.currentUser
        
        emailLabel.text = currentUser.email
        nameLabel.text = "\(currentUser.firstName) \(currentUser.lastName)"
        phoneLabel.text = currentUser.phone
        avatarImageView.setRoundCorner(avatarImageView.frame.width / 2.0)
        
        var statisticString = "You have placed \(currentUser.placedOrderCount) orders\n"
        statisticString = statisticString.appending("You have taken \(currentUser.takenOrderCount) orders\n")
        statisticString = statisticString.appending("You have earned \(GHConstant.kAmountFormatter.string(from: NSNumber(floatLiteral: currentUser.earnedMoney)) ?? "$0.00")")
        
        func matchesForRegexInText(regex: String, text: String) -> [NSRange] {
            let regex = try! NSRegularExpression(pattern: regex, options: .caseInsensitive)
            let nsString = text as NSString
            let results: [NSTextCheckingResult] = regex.matches(in: text, options: .reportCompletion, range: NSMakeRange(0, nsString.length))
            return results.map { $0.range }
        }
        
        let mutableAttributedString = NSMutableAttributedString(string: statisticString)
        for range in matchesForRegexInText(regex: "(\\d+)|(\\$\\d+\\.?\\d+)", text: statisticString) {
            mutableAttributedString.addAttributes([.font : UIFont.preferredFont(forTextStyle: .largeTitle)], range: range)
        }
        statisticsLabel.attributedText = mutableAttributedString
    }
    
    @IBAction func addCommunityAction(_ sender: UIButton) {
        let communityViewController = CommunitySearchTableViewController.embeddedInNavigationController(self, .add)
        present(communityViewController, animated: true)
    }
    
    @IBAction func logoutAction(_ sender: UIButton) {
        let ac = UIAlertController(title: "Logout", message: "Are you sure you want to logout?", preferredStyle: .alert)
        
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        ac.addAction(UIAlertAction(title: "Logout", style: .destructive, handler: { _ in
            self.logout()
        }))
        present(ac, animated: true)
    }
    
    func logout() {
        UserDefaultsHelper.shared.saveFaceID(false)
        UserHelper.shared.logout()
        UIView.transition(with: UIApplication.shared.windows.first!,
                          duration: GHConstant.kStoryboardTransitionDuration,
                          options: .transitionFlipFromLeft,
                          animations: {
                            UIApplication.shared.windows.first!.rootViewController = UIStoryboard(name: "LoginRegister", bundle: nil).instantiateInitialViewController()
        })
    }
    
    private func isCommunityIndexPath(_ indexPath: IndexPath) -> Bool {
        return indexPath.section == 2 && indexPath.row > 0
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 2 {
            return 1 + selectedCommunities.count
        } else {
            return super.tableView(tableView, numberOfRowsInSection: section)
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if isCommunityIndexPath(indexPath) {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileCommunityTableViewCell", for: indexPath)
            cell.textLabel?.text = selectedCommunities[indexPath.row - 1].name
            return cell
        } else {
            return super.tableView(tableView, cellForRowAt: indexPath)
        }
    }
    
    override func tableView(_ tableView: UITableView, indentationLevelForRowAt indexPath: IndexPath) -> Int {
        if isCommunityIndexPath(indexPath) {
            return super.tableView(tableView, indentationLevelForRowAt: IndexPath(row: 0, section: RegisterTableViewController.communitySection))
        }
        return super.tableView(tableView, indentationLevelForRowAt: indexPath)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return indexPath.section == 2 ? 50.0 : super.tableView(tableView, heightForRowAt: indexPath)
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if isCommunityIndexPath(indexPath) {
            selectedCommunities.remove(at: indexPath.row - 1)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        if isCommunityIndexPath(indexPath) {
            return .delete
        } else {
            return super.tableView(tableView, editingStyleForRowAt: indexPath)
        }
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return isCommunityIndexPath(indexPath)
    }

}

extension ProfileTableViewController: CommunitySearchTableViewControllerDelegate {
    
    func didSelectCommunity(_ community: CommunityModel) {
        if !selectedCommunities.contains(community) {
            selectedCommunities.append(community)
            tableView.reloadData()
        } else {
            SVProgressHUD.showInfo(withStatus: "You already belong to this community")
        }
    }
    
}

extension ProfileTableViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else {
            SVProgressHUD.showError(withStatus: "No locations found")
            return
        }
        
        selectedCommunities = MockDataStore.shared.communityList.filter {
            $0.distanceFromLocation(location) <= 3.0
        }
        tableView.reloadData()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        SVProgressHUD.showError(withStatus: error.localizedDescription)
    }
    
}

