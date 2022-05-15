//
//  LogInViewController.swift
//  Photo Buckets
//
//  Created by Jingkun Liu on 4/19/22.
//

import UIKit
import Firebase
import GoogleSignIn
import FirebaseEmailAuthUI
import FirebaseAuthUI
import FirebaseGoogleAuthUI
import FirebasePhoneAuthUI
import FirebaseOAuthUI
import FirebaseAnonymousAuthUI
import AuthenticationServices

class LogInViewController: UIViewController {
    
    var loginHandle: AuthStateDidChangeListenerHandle?
    var rosefireName: String?
    var rosefireEmail: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.rosefireEmail = nil
        self.rosefireName = nil
        self.loginHandle = AuthStateManager.shared.addLoginObserver {
            print("Log in complete, to go table view")
            self.performSegue(withIdentifier: Constants.ALBUMS_LIST_SEGUE, sender: self)
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        AuthStateManager.shared.removeObserver(authStateHandle: self.loginHandle)
    }
    
    @IBAction func roseFireLoginPressed(_ sender: Any) {
        print("You pressed ROSEFIRE Login")
        
        print("You pressed the rosefire")
        
        Rosefire.sharedDelegate().uiDelegate = self
        Rosefire.sharedDelegate().signIn(registryToken: Constants.ROSEFIRE_REGISTRY_TOKEN) { err, res in
            if let err = err {
                print("Rosefire signin error \(err)")
                return
            }
            
            print("Token    = \(res!.token!)")
            print("Username = \(res!.username!)")
            print("Name     = \(res!.name!)")
            print("Email    = \(res!.email!)")
            print("Group    = \(res!.group!)")
            
            self.rosefireEmail = res?.email
            self.rosefireName = res?.name
            AuthStateManager.shared.signInWithRoseFire(res!.token)
        }
    }
    @IBAction func googleSignInPressed(_ sender: Any) {
        print("Signning in with google ...")
        
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }
        
        // Create Google sign in configuration object
        let config = GIDConfiguration(clientID: clientID)
        
        // Start the sign in flow
        GIDSignIn.sharedInstance.signIn(with: config, presenting: self) { user, error in
            
            if let error = error {
                print("ERROR: \(error)")
                return
            }
            
            guard
                let auth = user?.authentication,
                let idToken = auth.idToken
            else { return }
            
            let credential = GoogleAuthProvider.credential(
                withIDToken: idToken,
                accessToken: auth.accessToken
            )
            
            AuthStateManager.shared.signInWithGoogleCredential(credential)
        }
    }
    
    @IBAction func appleSignInPressed(_ sender: Any) {
        print("Apple Sign in")
        
        let request = self.createAppleIDRequest()
        let authController = ASAuthorizationController(authorizationRequests: [request])
        
        authController.delegate = self
        authController.presentationContextProvider = self
        
        print("performing request ...")
        authController.performRequests()
        print("requests performed")
    }
    
    @IBAction func firebaseSignInPressed(_ sender: Any) {
        guard
            let authUI = FUIAuth.defaultAuthUI()
        else { return }
        
        authUI.delegate = self
        
        let providers: [FUIAuthProvider] = [
            FUIGoogleAuth.init(authUI: authUI),
            FUIOAuth.appleAuthProvider(),
            FUIEmailAuth(),
            FUIAnonymousAuth(authUI: authUI)
        ]
        
        authUI.providers = providers
        
        let authViewController = authUI.authViewController()
        
        self.present(authViewController, animated: true)
    }
    
    func createAppleIDRequest() -> ASAuthorizationAppleIDRequest {
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        
        let nonce = Utils.randomNonceString()
        request.nonce = Utils.sha256(nonce)
        AuthStateManager.shared.currentNonce = nonce
        
        return request
    }

}

@available(iOS 13.0, *)
extension LogInViewController: ASAuthorizationControllerDelegate {
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        print("Signning in to Firebase ...")
        
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            
            let appleUID = appleIDCredential.user
            print("User: \(appleUID)")
            print("Email: \(appleIDCredential.email ?? "")")
            print("Fullname: \(appleIDCredential.fullName?.description ?? "")")
            
            guard let nonce = AuthStateManager.shared.currentNonce else {
                fatalError("Invalid state: A login callback was received, but no login request was sent.")
            }
            
            guard let appleIDToken = appleIDCredential.identityToken else {
                print("Unable to fetch identity token")
                return
            }
            
            guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
                print("Unable to serialize token string from data: \(appleIDToken.debugDescription)")
                return
            }
            
            ASAuthorizationAppleIDProvider().getCredentialState(forUserID: appleUID) { credState, err in
                if let err = err {
                    print("Get credential state error: \(err)")
                    return
                }
                
                switch credState {
                case .authorized:
                    // Initialize a Firebase credential.
                    let credential = OAuthProvider.credential(
                        withProviderID: "apple.com",
                        idToken: idTokenString,
                        rawNonce: nonce
                    )
                    
                    AuthStateManager.shared.signInWithAppleCredential(credential)
                default:
                    print("Authorization fauked")
                }
            }
        }
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print("Apple Auth error \(error)")
    }
}

extension LogInViewController: ASAuthorizationControllerPresentationContextProviding, FUIAuthDelegate {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
    
    func authUI(_ authUI: FUIAuth, didSignInWith user: User?, error: Error?) {
        authUI.authViewController().dismiss(animated: true)
        if let err = error {
            print("Firebase Auth Error: \(err)")
            return
        }
        
        print("User \(user!.uid) signed in with FirebaseUI\n")
//        self.performSegue(withIdentifier: Constants.PHOTO_LIST_SEGUE, sender: self)
    }
    
    // MARK: Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constants.ALBUMS_LIST_SEGUE {
            UserDocumentManager.shared.addNewUserMaybe(
                uid: AuthStateManager.shared.currentUser!.uid,
                name: self.rosefireName ?? AuthStateManager.shared.currentUser?.displayName,
                email: self.rosefireEmail ?? AuthStateManager.shared.currentUser?.email,
                photoUrl: AuthStateManager.shared.currentUser!.photoURL?.absoluteString
            )
            print("Rose email: \(self.rosefireEmail ?? "")")
        }
    }
}
