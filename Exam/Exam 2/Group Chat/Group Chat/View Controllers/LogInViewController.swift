//
//  LogInViewController.swift
//  Group Chat
//
//  Created by Jingkun Liu on 5/5/22.
//

import UIKit
import Toast

class LogInViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    var welcomeViewController: WelcomePageViewController {
        let navViewController = self.presentingViewController as! UINavigationController
        return navViewController.viewControllers.last as! WelcomePageViewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.emailTextField.placeholder = "Email"
        self.passwordTextField.placeholder = "Password"
    }
    
    // MARK: Button Actions
    
    @IBAction func cancelPressed(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    @IBAction func loginButtonPressed(_ sender: Any) {
        self.dismiss(animated: true)
        guard
            let email = self.emailTextField.text,
            let password = self.passwordTextField.text
        else { return }
        
        AuthStateManager.shared.logInExistingEmailPasswordUser(
            email: email,
            password: password
        ) {
            self.welcomeViewController.view.makeToast("Log in Failed", duration: 1.0)
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
