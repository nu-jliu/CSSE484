//
//  MessagesSideMenuViewController.swift
//  Group Chat
//
//  Created by Jingkun Liu on 5/8/22.
//

import UIKit

class MessagesSideMenuViewController: UIViewController {

    var messagesTableViewController: MessagesTableViewController {
        let navController = self.presentingViewController as! UINavigationController
        return navController.viewControllers.last as! MessagesTableViewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    // MARK: - Button actions
    
    @IBAction func deleteMessagesPressed(_ sender: Any) {
        self.dismiss(animated: true)
        self.messagesTableViewController.tableView.isEditing = !self.messagesTableViewController.tableView.isEditing
    }
    
    @IBAction func backToGroupsPressed(_ sender: Any) {
        self.dismiss(animated: true)
        
        self.messagesTableViewController
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
