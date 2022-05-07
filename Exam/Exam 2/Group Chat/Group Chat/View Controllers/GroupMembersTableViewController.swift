//
//  GroupMembersTableViewController.swift
//  Group Chat
//
//  Created by Jingkun Liu on 5/5/22.
//

import UIKit
import Firebase
import Toast

class MemberInfoCell: UITableViewCell {
    @IBOutlet weak var memberNameLabel: UILabel!
    @IBOutlet weak var memberEmailLabel: UILabel!
}

class GroupMembersTableViewController: UITableViewController {
    
    var documentId: String?
    
    var groupListenerRegisteration: ListenerRegistration?
    var usersListenerRegisteration: ListenerRegistration?
    
    var memberNames = [String]()
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(self.showAddDialog)
        )
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.groupListenerRegisteration = MembersListManager.shared.startListening(for: self.documentId!) {
            
            self.navigationItem.title = MembersListManager.shared.latestGroup?.name ?? ""
            self.tableView.reloadData()
        }
        
        self.usersListenerRegisteration = AllUsersManger.shared.startsListenering {
            self.tableView.reloadData()
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        MembersListManager.shared.stopListening(self.groupListenerRegisteration)
        AllUsersManger.shared.stopListening(self.usersListenerRegisteration)
    }
    
    // MARK: - Button Actions
    
    @objc func showAddDialog() {
        let alertController = UIAlertController(title: "Add a New Member", message: nil, preferredStyle: .alert)
        
        alertController.addTextField { textfield in
            textfield.placeholder = "Member Email(s), seperated by \", \""
        }
        
        // add action
        alertController.addAction(UIAlertAction(
            title: "Add Member(s)",
            style: .default
        ) { action in
            let emailList = alertController.textFields![0].text!
            let emails = emailList.components(separatedBy: ", ")
            
            MembersListManager.shared.addMember(emails: emails) { message in
                let errorAlertController = UIAlertController(title: "Add User Failed", message: message, preferredStyle: .alert)
                
                errorAlertController.addAction(UIAlertAction(title: "OK", style: .cancel))
                
                self.present(errorAlertController, animated: true)
            }
        })
        
        // cancel action
        alertController.addAction(UIAlertAction(
            title: "Cancel",
            style: .cancel
        ))
        
        self.present(alertController, animated: true)
    }
    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return MembersListManager.shared.latestGroup?.memberEmails.count ?? 0
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: Constants.GROUP_MEMBER_CELL_IDENTIFIER,
            for: indexPath
        ) as! MemberInfoCell

        // Configure the cell...
        if let email = MembersListManager.shared.latestGroup?.memberEmails[indexPath.row] {
            cell.memberEmailLabel.text = email
            cell.memberNameLabel.text = AllUsersManger.shared.emailNameMap[email]
        }
        
        return cell
    }
    

    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        let email = MembersListManager.shared.latestGroup?.memberEmails[indexPath.row]
        return email != MembersListManager.shared.latestGroup?.ownerEmail
    }
    

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            MembersListManager.shared.removeMember(
                email: MembersListManager.shared.latestGroup?.memberEmails[indexPath.row] ?? ""
            )
        }
//        else if editingStyle == .insert {
//            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
//        }
    }
    

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
