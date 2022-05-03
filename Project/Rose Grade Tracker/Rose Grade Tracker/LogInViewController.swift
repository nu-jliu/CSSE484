//
//  LogInViewController.swift
//  Rose Grade Tracker
//
//  Created by Jingkun Liu on 4/30/22.
//

import UIKit
import Firebase

class LogInViewController: UIViewController {
    
    private var logInHandle: AuthStateDidChangeListenerHandle?
    var rosefireName: String?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.logInHandle = AuthManager.shared.addLoginObserver {
            self.performSegue(withIdentifier: Constants.SHOW_COURSE_LIST_SEQUE, sender: self)
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        AuthManager.shared.removeObserver(self.logInHandle)
        
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        .darkContent
    }
    
    @IBAction func rosefireLoginPressed(_ sender: Any) {
        print("You pressed the rosefire")
        
        Rosefire.sharedDelegate().uiDelegate = self
        Rosefire.sharedDelegate().signIn(registryToken: Constants.ROSEFIRE_REGISTRY_TOKEN) { err, res in
            if let err = err {
                print("Rosefire signin error \(err)")
                return
            }
            
//            print("Result = \(res!.token!)")
//            print("Result = \(res!.username!)")
            print("Name = \(res!.name!)")
            self.rosefireName = res?.name
//            print("Result = \(res!.email!)")
            print("Group = \(res!.group!)")
            
            AuthManager.shared.signInwithRoseifreToken(res!.token!)
        }
    }
    
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        print("Segue identifier: \(segue.identifier ?? "")")
        if segue.identifier == Constants.SHOW_COURSE_LIST_SEQUE {
                    print("Name = \(self.rosefireName ?? "")")
                    print("PhotoUrl = \(AuthManager.shared.currentUser?.photoURL?.absoluteString ?? "")")
                    
                    UserDocumentManager.shared.addNewUserMaybe(
                        uid: AuthManager.shared.currentUser!.uid,
                        name: self.rosefireName,
                        photoUrl: AuthManager.shared.currentUser?.photoURL?.absoluteString
                    )
                }
    }
    

}
