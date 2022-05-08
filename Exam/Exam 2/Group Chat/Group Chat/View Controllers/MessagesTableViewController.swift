//
//  MessagesTableViewController.swift
//  Group Chat
//
//  Created by Jingkun Liu on 5/7/22.
//

import UIKit
import Firebase

class MyMessageTableViewCell: UITableViewCell {
    @IBOutlet weak var myMessageLabel: UILabel!
    @IBOutlet weak var myMessageView: UIView!
}

class OthersMessageTableViewCell: UITableViewCell {
    @IBOutlet weak var authorNameLabel: UILabel!
    @IBOutlet weak var othersMessageLabel: UILabel!
    @IBOutlet weak var othersMessageView: UIView!
}

class MessagesTableViewController: UITableViewController {

    var messagesListenerRegisteration: ListenerRegistration?
    var usersListenerRegisteration: ListenerRegistration?
    var groupId: String?
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(self.showAddDialog))
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.messagesListenerRegisteration = MessagesCollectionManager.shared.startListening(for: self.groupId!) {
            self.tableView.reloadData()
        }
        
        self.usersListenerRegisteration = AllUsersManger.shared.startsListenering {
            self.tableView.reloadData()
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        MessagesCollectionManager.shared.stopListening(self.messagesListenerRegisteration)
        
        AllUsersManger.shared.stopListening(self.usersListenerRegisteration)
    }
    
    // MARK: - Bar button actions
    
    @objc func showAddDialog() {
        let alertController = UIAlertController(title: "Send a Message", message: nil, preferredStyle: .alert)
        
        // message text
        alertController.addTextField { textField in
            textField.placeholder = "Text"
        }
        
        // Send action
        alertController.addAction(UIAlertAction(
            title: "Send",
            style: .default
        ) { action in
            if let email = AuthStateManager.shared.currentUser?.email {
                if let text = alertController.textFields![0].text {
                    let message = Message(sender: email, text: text)
                    
                    MessagesCollectionManager.shared.add(message)
                }
            }
        })
        
        // cancel action
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        self.present(alertController, animated: true)
    }
    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return MessagesCollectionManager.shared.latestMessages.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let message = MessagesCollectionManager.shared.latestMessages[indexPath.row]
        
        if message.sender == AuthStateManager.shared.currentUser?.email {
            let cell = tableView.dequeueReusableCell(
                withIdentifier: Constants.MY_MESSAGE_CELL_IDENTIFIER,
                for: indexPath
            ) as! MyMessageTableViewCell
            
            // Configure cell ...
            cell.myMessageLabel.text = message.text
            cell.myMessageView.layer.cornerRadius = 15
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(
                withIdentifier: Constants.OTHERS_MESSAGE_CELL_IDENTIFIER,
                for: indexPath
            ) as! OthersMessageTableViewCell
            
            // Configure cell ...
            cell.authorNameLabel.text = AllUsersManger.shared.emailNameMap[message.sender]
            cell.othersMessageLabel.text = message.text
            cell.othersMessageView.layer.cornerRadius = 15
            
            return cell
        }
    }
    

    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return MessagesCollectionManager.shared.latestMessages[indexPath.row].sender == AuthStateManager.shared.currentUser?.email
    }
    

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            if let docId = MessagesCollectionManager.shared.latestMessages[indexPath.row].documentId {
                MessagesCollectionManager.shared.delete(docId)
            }
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
        if segue.identifier == Constants.SHOW_MESSAGE_DETAIL_SEGUE {
            let messageDetailVC = segue.destination as! MessageDetailViewController
            if let indexPath = self.tableView.indexPathForSelectedRow {
                let message = MessagesCollectionManager.shared.latestMessages[indexPath.row]
                
                messageDetailVC.groupId = self.groupId
                messageDetailVC.docId = message.documentId
            }
        }
    }
    

}
