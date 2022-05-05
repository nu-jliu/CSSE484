//
//  RegisterViewController.swift
//  Group Chat
//
//  Created by Jingkun Liu on 5/5/22.
//

import UIKit

class RegisterViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    var welcomePageViewController: WelcomePageViewController {
        let navController = self.presentingViewController as! UINavigationController
        return navController.viewControllers.last as! WelcomePageViewController
    }

    // MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.emailTextField.placeholder = "Email"
        self.firstNameTextField.placeholder = "First Name"
        self.lastNameTextField.placeholder = "Last Name"
        self.passwordTextField.placeholder = "Password"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    // MARK: Button Actions
    
    @IBAction func cancelPressed(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    @IBAction func registerButtonPressed(_ sender: Any) {
        self.dismiss(animated: true)
        
        let firstName = self.firstNameTextField.text
        let lastName = self.lastNameTextField.text
        
        guard
            let email = self.emailTextField.text,
            let password = self.passwordTextField.text
        else { return }
        
        self.welcomePageViewController.userFirstName = firstName
        self.welcomePageViewController.userLastName = lastName
        
        AuthStateManager.shared.signInNewEmailPasswordUser(
            email: email,
            password: password
        )
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
