//
//  MessageDetailViewController.swift
//  Group Chat
//
//  Created by Jingkun Liu on 5/8/22.
//

import UIKit
import Firebase

class MessageDetailViewController: UIViewController {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var messageTextView: UIView!
    
    var userListenerRegisteration: ListenerRegistration?
    var messageListenerRegissteration: ListenerRegistration?
    
    var groupId: String?
    var docId: String?
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.messageTextView.layer.cornerRadius = 15
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.userListenerRegisteration = AllUsersManger.shared.startsListenering {
            self.updateView()
        }
        
        self.messageListenerRegissteration = MessageDocumentManager.shared.startListening(forGroup: self.groupId!, for: self.docId!) {
            self.updateView()
            
            if MessageDocumentManager.shared.latestMessage?.sender == AuthStateManager.shared.currentUser?.email {
                self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(self.showEditDialog))
            } else {
                self.messageTextView.backgroundColor = UIColor(red: 152/255, green: 211/255, blue: 255/255, alpha: 1)
            }
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        AllUsersManger.shared.stopListening(self.userListenerRegisteration)
        MessageDocumentManager.shared.stopListening(self.messageListenerRegissteration)
    }
    
    // MARK: - Button actions
    
    @objc func showEditDialog() {
        let alertController = UIAlertController(title: "Edit Message", message: nil, preferredStyle: .alert)
        
        // message text field
        alertController.addTextField { textField in
            textField.placeholder = "Message Text"
            textField.text = MessageDocumentManager.shared.latestMessage?.text
        }
        
        // sunmit action
        alertController.addAction(UIAlertAction(title: "Submit", style: .default) { action in
            if let text = alertController.textFields![0].text {
                MessageDocumentManager.shared.update(text: text)
            }
        })
        
        // cancel action
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        self.present(alertController, animated: true)
    }

    // MARK: Update view
    
    func updateView() {
        if let email = MessageDocumentManager.shared.latestMessage?.sender {
            self.nameLabel.text = AllUsersManger.shared.emailNameMap[email]
            self.emailLabel.text = email
        }
        
        if let text = MessageDocumentManager.shared.latestMessage?.text {
            self.messageLabel.text = text
        }
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
