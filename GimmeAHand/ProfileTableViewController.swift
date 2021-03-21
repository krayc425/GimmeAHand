//
//  ProfileTableViewController.swift
//  GimmeAHand
//
//  Created by Yifan Huang on 3/20/21.
//

import UIKit

class ProfileTableViewController: UITableViewController {
    struct CellPositions {
        struct Section {
            static let photo = 0
            static let email = 0
            static let firstName = 0
            static let lastName = 0
            static let phone = 0
            static let aboutMe = 1
            static let community = 2
        }
        
        struct Row {
            static let photo = 0
            static let email = 1
            static let firstName = 2
            static let lastName = 3
            static let phone = 4
            static let aboutMe = 0
        }
    }
    
    struct FakeDatastore {
        static let email = "john.doe@example.com"
        static let firstName = "John"
        static let lastName = "Doe"
        static let phone = "111-222-3333"
        static let aboutMe = "HAHAHAHAHAHAHA!"
    }
    
    @IBOutlet weak var addCommunityButton: UIButton!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var firstNameLabel: UILabel!
    @IBOutlet weak var lastNameLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var aboutMeLabel: UILabel!
    @IBOutlet weak var changePasswordBotton: UIButton!
    @IBOutlet weak var logoutBottom: UIButton!
    
    var selectedCommunities: [String] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "ProfileCommunityTableViewCell")
        
        emailLabel.text = FakeDatastore.email
        firstNameLabel.text = FakeDatastore.firstName
        lastNameLabel.text = FakeDatastore.lastName
        phoneLabel.text = FakeDatastore.phone
        aboutMeLabel.text = FakeDatastore.aboutMe

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 5
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == CellPositions.Section.community {
            return 1 + selectedCommunities.count
        } else {
            return super.tableView(tableView, numberOfRowsInSection: section)
        }
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if isCommunityIndexPath(indexPath) {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileCommunityTableViewCell", for: indexPath)
            cell.textLabel?.text = selectedCommunities[indexPath.row - 1]
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
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == CellPositions.Section.photo && indexPath.row == CellPositions.Row.photo {
            return 140
        }
        
        return indexPath.section == CellPositions.Section.community ? 50.0 : 44.0
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if isCommunityIndexPath(indexPath) {
            selectedCommunities.remove(at: indexPath.row - 1)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        if isCommunityIndexPath(indexPath) {
            return UITableViewCell.EditingStyle.delete
        } else {
            return super.tableView(tableView, editingStyleForRowAt: indexPath)
        }
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return isCommunityIndexPath(indexPath)
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Unselect the row.
        tableView.deselectRow(at: indexPath, animated: false)
        
        if indexPath.section == CellPositions.Section.photo && indexPath.row == CellPositions.Row.photo {
            let ac = UIAlertController(title: "Edit Phone", message: "How would you like to edit your photo?", preferredStyle: .alert)
            
            ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
            ac.addAction(UIAlertAction(title: "From Photos", style: .default))
            ac.addAction(UIAlertAction(title: "Open Camera", style: .default))
            self.present(ac, animated: true)
        } else if indexPath.section == CellPositions.Section.email && indexPath.row == CellPositions.Row.email {
            let ac = UIAlertController(title: "Edit Email", message: "Please specify a new email", preferredStyle: .alert)
            
            ac.addTextField{(emailText) -> Void in
                emailText.placeholder = self.emailLabel.text
            }
            
            ac.addTextField{(secondEmailText) -> Void in
                secondEmailText.placeholder = "Please confirm your new email."
            }
            
            ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
            ac.addAction(UIAlertAction(title: "OK", style: .default, handler: {alertAction in
                let newInput = ac.textFields?.first?.text
                self.emailLabel.text = newInput
            }))
            self.present(ac, animated: true)
        } else if indexPath.section == CellPositions.Section.firstName && indexPath.row == CellPositions.Row.firstName {
            let ac = UIAlertController(title: "Edit First Name", message: "Please specify a new first name.", preferredStyle: .alert)
            
            ac.addTextField{(firstNameText) -> Void in
                firstNameText.placeholder = self.firstNameLabel.text
            }
            
            ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
            ac.addAction(UIAlertAction(title: "OK", style: .default, handler: {alertAction in
                let newInput = ac.textFields?.first?.text
                self.firstNameLabel.text = newInput
            }))
            self.present(ac, animated: true)
        } else if indexPath.section == CellPositions.Section.lastName && indexPath.row == CellPositions.Row.lastName {
            let ac = UIAlertController(title: "Edit Last Name", message: "Please specify a new last name.", preferredStyle: .alert)
            
            ac.addTextField{(lastNameText) -> Void in
                lastNameText.placeholder = self.lastNameLabel.text
            }
            
            ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
            ac.addAction(UIAlertAction(title: "OK", style: .default, handler: {alertAction in
                let newInput = ac.textFields?.first?.text
                self.lastNameLabel.text = newInput
            }))
            self.present(ac, animated: true)
        } else if indexPath.section == CellPositions.Section.phone && indexPath.row == CellPositions.Row.phone {
            let ac = UIAlertController(title: "Edit Phone Number", message: "Please specify a new phone number.", preferredStyle: .alert)
            
            ac.addTextField{(phoneText) -> Void in
                phoneText.placeholder = self.phoneLabel.text
            }
            
            ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
            ac.addAction(UIAlertAction(title: "OK", style: .default, handler: {alertAction in
                let newInput = ac.textFields?.first?.text
                self.phoneLabel.text = newInput
            }))
            self.present(ac, animated: true)
        } else if indexPath.section == CellPositions.Section.aboutMe && indexPath.row == CellPositions.Row.aboutMe {
            let ac = UIAlertController(title: "Edit About Me", message: "What would you want to say here?", preferredStyle: .alert)
            
            ac.addTextField{(aboutMeText) -> Void in
                aboutMeText.placeholder = self.aboutMeLabel.text
            }
            
            ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
            ac.addAction(UIAlertAction(title: "OK", style: .default, handler: {alertAction in
                let newInput = ac.textFields?.first?.text
                self.aboutMeLabel.text = newInput
            }))
            self.present(ac, animated: true)
        }
    }
    
    @IBAction func addCommunityAction(_ sender: UIButton) {
        let communityViewController = CommunitySearchTableViewController.embeddedInNavigationController(self)
        present(communityViewController, animated: true)
    }
    
    @IBAction func changePasswordAction(_ sender: UIButton) {
        let ac = UIAlertController(title: "Edit Password", message: "Please specify a new password.", preferredStyle: .alert)
        
        ac.addTextField{(passwordText) -> Void in
            passwordText.placeholder = "10-20 letters/digits/(!@#$%^&*)"
            passwordText.isSecureTextEntry = true
        }
        
        ac.addTextField{(secondPasswordText) -> Void in
            secondPasswordText.placeholder = "Please confirm your new password."
            secondPasswordText.isSecureTextEntry = true
        }
        
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        self.present(ac, animated: true)
    }
    
    @IBAction func logoutAction(_ sender: UIButton) {
        let ac = UIAlertController(title: "Logout", message: "Are you sure you want to logout?", preferredStyle: .alert)
        
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        ac.addAction(UIAlertAction(title: "Yes", style: .default))
        self.present(ac, animated: true)
    }
    
    private func isCommunityIndexPath(_ indexPath: IndexPath) -> Bool {
        return indexPath.section == CellPositions.Section.community && indexPath.row > 0
    }
    
    
    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension ProfileTableViewController: CommunitySearchTableViewControllerDelegate {
    func didSelectCommunity(_ community: String) {
        selectedCommunities.append(community)
        tableView.reloadData()
    }
    
}