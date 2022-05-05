//
//  UserProfileViewController.swift
//  Group Chat
//
//  Created by Jingkun Liu on 5/5/22.
//

import UIKit
import Firebase

class UserProfileViewController: UIViewController {

    
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    
    var userListenerRegisteration: ListenerRegistration?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.firstNameTextField.placeholder = "First Name"
        self.lastNameTextField.placeholder = "Last Name"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let email = AuthStateManager.shared.currentUser?.email {
            self.userListenerRegisteration = UserDocumentManager.shared.startListening(for: email) {
                self.firstNameTextField.text = UserDocumentManager.shared.firstName
                self.lastNameTextField.text = UserDocumentManager.shared.lastName
            }
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        UserDocumentManager.shared.stopListening(self.userListenerRegisteration)
    }
    
    @IBAction func updateButtonPressed(_ sender: Any) {
        guard
            let firstName = self.firstNameTextField.text,
            let lastName = self.lastNameTextField.text
        else { return }
        
        UserDocumentManager.shared.updateName(first: firstName, last: lastName)
        self.navigationController?.popViewController(animated: true)
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
