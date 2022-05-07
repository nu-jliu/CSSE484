//
//  GroupMembersSideMenuViewController.swift
//  Group Chat
//
//  Created by Jingkun Liu on 5/6/22.
//

import UIKit

class GroupMembersSideMenuViewController: UIViewController {
    
    @IBOutlet weak var renameGroupButton: UIButton!
    @IBOutlet weak var leaveGroupButton: UIButton!
    
    var groupMemberTableViewController: GroupMembersTableViewController {
        let navController = self.presentingViewController as! UINavigationController
        return navController.viewControllers.last as! GroupMembersTableViewController
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if AuthStateManager.shared.currentUser?.email == MembersListManager.shared.latestGroup?.ownerEmail {
            self.leaveGroupButton.isHidden = true
        } else {
            self.renameGroupButton.isHidden = true
        }
        self.navigationItem.title = MembersListManager.shared.latestGroup?.ownerEmail ?? ""
    }
    
    // MARK: - Button Actions
    
    @IBAction func renameGroupPressed(_ sender: Any) {
        self.dismiss(animated: true)
        
        let alertController = UIAlertController(title: "Update Group Name", message: nil, preferredStyle: .alert)
        
        alertController.addTextField { textField in
            textField.text = MembersListManager.shared.latestGroup?.name
            textField.placeholder = "New Group Name"
        }
        
        alertController.addAction(UIAlertAction(
            title: "Update",
            style: .default
        ) { action in
            let name = alertController.textFields![0].text!
            
            MembersListManager.shared.updateGroup(newName: name)
        })
        
        alertController.addAction(UIAlertAction(
            title: "Cancel",
            style: .cancel
        ))
        
        self.groupMemberTableViewController.present(alertController, animated: true)
    }
    
    @IBAction func removeMembersPressed(_ sender: Any) {
        self.dismiss(animated: true)
        self.groupMemberTableViewController.isEditing = !self.groupMemberTableViewController.isEditing
    }
    
    @IBAction func leaveGroupPressed(_ sender: Any) {
        self.dismiss(animated: true)
        self.groupMemberTableViewController
            .navigationController?
            .popViewController(animated: true)
        
        let alertController = UIAlertController(
            title: "Leave Group",
            message: "Would you like to live the group \(MembersListManager.shared.latestGroup?.name ?? "")?",
            preferredStyle: .alert
        )
        
        // Leave action
        alertController.addAction(UIAlertAction(
            title: "Leave",
            style: .default) { action in
                MembersListManager.shared.removeMember(
                    email: AuthStateManager.shared.currentUser?.email ?? ""
                )
        })
        
        // Cancel Action
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        self.groupMemberTableViewController.present(alertController, animated: true)
    }
    
    @IBAction func backToGroupsPressed(_ sender: Any) {
        self.dismiss(animated: true)
        
        self.groupMemberTableViewController
            .navigationController?
            .popViewController(animated: true)
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
