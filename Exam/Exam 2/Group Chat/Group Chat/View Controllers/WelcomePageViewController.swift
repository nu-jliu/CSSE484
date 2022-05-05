//
//  WelcomePageViewController.swift
//  Group Chat
//
//  Created by Jingkun Liu on 5/5/22.
//

import UIKit
import Firebase

class WelcomePageViewController: UIViewController {
    
    var loginHandle: AuthStateDidChangeListenerHandle?
    
    var userFirstName: String?
    var userLastName: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.loginHandle = AuthStateManager.shared.addLoginObserver {
            self.performSegue(withIdentifier: Constants.SHOW_LIST_SEGUE, sender: self)
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        AuthStateManager.shared.removeObserver(self.loginHandle)
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == Constants.SHOW_LIST_SEGUE {
            
            print("User firstname = \(self.userFirstName ?? ""), lastname = \(self.userLastName ?? "")")
            
            if let email = AuthStateManager.shared.currentUser?.email {
                UserDocumentManager.shared.addNewUserMaybe(
                    email: email,
                    firstName: self.userFirstName,
                    lastName: self.userLastName
                )
            }
        }
    }
    

}
