//
//  GroupsSideMenuViewController.swift
//  Group Chat
//
//  Created by Jingkun Liu on 5/5/22.
//

import UIKit

class GroupsSideMenuViewController: UIViewController {

    var groupsTableViewController: GroupsTableViewController {
        let navController = self.presentingViewController as! UINavigationController
        return navController.viewControllers.last as! GroupsTableViewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    // MARK: Button Actions
    
    @IBAction func editProfileButtonPressed(_ sender: Any) {
    }
    
    @IBAction func deleteGroupButtonPressed(_ sender: Any) {
        self.dismiss(animated: true)
        self.groupsTableViewController.isEditing = !self.groupsTableViewController.isEditing
    }
    
    @IBAction func signOutButtonPressed(_ sender: Any) {
        self.dismiss(animated: true)
        AuthStateManager.shared.signOut()
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
