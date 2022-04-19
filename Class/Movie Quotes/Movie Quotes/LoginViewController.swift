//
//  LoginViewController.swift
//  Movie Quotes
//
//  Created by Jingkun Liu on 4/18/22.
//

import UIKit
import Firebase
import GoogleSignIn

class LoginViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    var loginHandle: AuthStateDidChangeListenerHandle?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.emailTextField.placeholder = "email"
        self.passwordTextField.placeholder = "password"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.loginHandle = AuthManager.shared.addLoginObserver {
            print("Login complete, go to the listview")
            self.performSegue(withIdentifier: SHOW_LIST_SEGUE, sender: self)
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        AuthManager.shared.removeObserver(self.loginHandle)
    }
    
    @IBAction func pressedRosefire(_ sender: Any) {
        print("You pressed the rosefire")
        
        Rosefire.sharedDelegate().uiDelegate = self
        Rosefire.sharedDelegate().signIn(registryToken: ROSEFIRE_REGISTRY_TOKEN) { err, res in
            if let err = err {
                print("Rosefire signin error \(err)")
                return
            }
            
            print("Result = \(res!.token!)")
            print("Result = \(res!.username!)")
            print("Result = \(res!.name!)")
            print("Result = \(res!.email!)")
            print("Result = \(res!.group!)")
            
            AuthManager.shared.signInwithRoseifreToken(res!.token!)
        }
    }
    
    @IBAction func createUserPressed(_ sender: Any) {
        let email = self.emailTextField.text!
        let pass = self.passwordTextField.text!
        
        print("Login new user: email: \(email), pass: \(pass)")
        
        AuthManager.shared.signInNewEmailPasswordUser(email: email, password: pass)
    }
    
    @IBAction func logInExistingUserPressed(_ sender: Any) {
        let email = self.emailTextField.text!
        let pass = self.passwordTextField.text!
        
        print("Login new user: email: \(email), pass: \(pass)")
        
        AuthManager.shared.logInExistingEmailPasswordUser(email: email, password: pass)
    }
    
    
    @IBAction func pressedGoogleSignin(_ sender: Any) {
        print("Sign in with Google")
        
        guard let clientID = FirebaseApp.app()?.options.clientID else {
            return
        }
        
        let config = GIDConfiguration(clientID: clientID)
        
        GIDSignIn.sharedInstance.signIn(with: config, presenting: self) { user, err in
            
            if let err = err {
                print("Error with Google sign in \(err)")
                return
            }
            
            guard
                let auth = user?.authentication,
                let idToken = auth.idToken
            else {
                return
            }
            
            let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: auth.accessToken)
            
//            print("\(credential.provider)")
            AuthManager.shared.signInWithGoogleCredential(credential)
        }
    }
}
