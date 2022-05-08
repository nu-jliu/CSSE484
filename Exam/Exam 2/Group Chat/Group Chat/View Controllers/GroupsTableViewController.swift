//
//  GroupsTableViewController.swift
//  Group Chat
//
//  Created by Jingkun Liu on 5/5/22.
//

import UIKit
import Firebase

class GroupCell: UITableViewCell {
    @IBOutlet weak var groupNameLabel: UILabel!
    @IBOutlet weak var showMembersButton: UIButton!
}

class GroupsTableViewController: UITableViewController {
    
    var logoutHandle: AuthStateDidChangeListenerHandle?
    var groupsListerRegisteration: ListenerRegistration?
    var usersListenerRegisteration: ListenerRegistration?
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(self.showAddAlertDialog))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.logoutHandle = AuthStateManager.shared.addLogoutObserver {
            self.navigationController?.popViewController(animated: true)
        }
        
        self.groupsListerRegisteration = GroupsCollectionManager.shared.startListening {
            self.tableView.reloadData()
        }
        
        self.usersListenerRegisteration = AllUsersManger.shared.startsListenering {
            print("Users updated")
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        AuthStateManager.shared.removeObserver(self.logoutHandle)
        
        GroupsCollectionManager.shared.stopListening(self.groupsListerRegisteration)
        
        AllUsersManger.shared.stopListening(self.usersListenerRegisteration)
    }
    
    // MARK: Bar Button Actions
    
    @objc func showAddAlertDialog() {
        let alertController = UIAlertController(title: "Create a New Group", message: "", preferredStyle: .alert)
        
        // text field for group name
        alertController.addTextField { textField in
            textField.placeholder = "Group Name"
        }
        
        alertController.addTextField { textField in
            textField.placeholder = "Member Email(s), seperated by \", \""
        }
        
        // add action
        alertController.addAction(UIAlertAction(
            title: "Add Group",
            style: .default
        ) { action in
            let groupName = alertController.textFields![0].text
            
            var emails = [String]()
            if let memberEmailStr = alertController.textFields![1].text {
                let memberEmails = memberEmailStr.components(separatedBy: ", ")
            
                for newEmail in memberEmails {
                    if AllUsersManger.shared.emailNameMap.keys.contains(newEmail) {
                        emails.append(newEmail)
                    }
                }
            }
            
            if let email = AuthStateManager.shared.currentUser?.email {
                let group = Group(name: groupName ?? "", ownerEmail: email, memberEmails: emails)
                GroupsCollectionManager.shared.add(group)
            }
            
            GroupsCollectionManager.shared.stopListening(self.groupsListerRegisteration)
            self.groupsListerRegisteration = GroupsCollectionManager.shared.startListening {
                self.tableView.reloadData()
            }
        })

        // Cancel Action
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        self.present(alertController, animated: true)
    }
    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return GroupsCollectionManager.shared.latestGroups.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.GROUP_CELL_IDENTIFIER, for: indexPath) as! GroupCell

        // Configure the cell...
        let group = GroupsCollectionManager.shared.latestGroups[indexPath.row]
        cell.groupNameLabel.text = group.name
        cell.showMembersButton.tag = indexPath.row
        
        return cell
    }
    

    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return GroupsCollectionManager.shared.latestGroups[indexPath.row].ownerEmail == AuthStateManager.shared.currentUser?.email
    }
    

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
//            tableView.deleteRows(at: [indexPath], with: .fade)
            let docId = GroupsCollectionManager.shared.latestGroups[indexPath.row].documentId!
            GroupsCollectionManager.shared.delete(docId)
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

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == Constants.GROUP_MEMBER_SEGUE_IDENTIFIER {
            let groupMemberVC = segue.destination as! GroupMembersTableViewController
            let memberButton = sender as! UIButton
            let group = GroupsCollectionManager.shared.latestGroups[memberButton.tag]
            
            print("Current row: \(memberButton.tag)")
            groupMemberVC.documentId = group.documentId
        } else if segue.identifier == Constants.SHOW_MESSAGE_LIST_SEGUE {
            let messagesTableVC = segue.destination as! MessagesTableViewController
            if let row = self.tableView.indexPathForSelectedRow?.row {
                let group = GroupsCollectionManager.shared.latestGroups[row]
                messagesTableVC.groupId = group.documentId
            }
        }
    }
    

}
