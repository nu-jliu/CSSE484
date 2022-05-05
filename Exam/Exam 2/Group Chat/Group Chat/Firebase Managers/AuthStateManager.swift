//
//  AuthStateManager.swift
//  Group Chat
//
//  Created by Jingkun Liu on 5/5/22.
//

import Foundation
import Firebase

enum LoginState {
    case success, failed
}

class AuthStateManager {
    
    static let shared = AuthStateManager()
    
    private init() {}
    
    var currentUser: User? {
        Auth.auth().currentUser
    }
    
    var isSignedIn: Bool {
        currentUser != nil
    }
    
    func addLoginObserver(callback: @escaping (() -> Void)) -> AuthStateDidChangeListenerHandle {
        return Auth.auth().addStateDidChangeListener { auth, user in
            if user != nil {
                callback()
            }
        }
    }
    
    func addLogoutObserver(callback: @escaping (() -> Void)) -> AuthStateDidChangeListenerHandle {
        return Auth.auth().addStateDidChangeListener { auth, user in
            if user == nil {
                callback()
            }
        }
    }
    
    func removeObserver(_ authDidChangeHandle: AuthStateDidChangeListenerHandle?) {
        //        if authDidChangeHandle != nil {
        //            Auth.auth().removeStateDidChangeListener(authDidChangeHandle)
        //        }
        if let authHandle = authDidChangeHandle {
            Auth.auth().removeStateDidChangeListener(authHandle)
        }
    }
    
    func signInNewEmailPasswordUser(email: String, password: String) {
        Auth.auth().createUser(withEmail: email, password: password) { authResult, err in
            if let error = err {
                print("ERROR: creating user failed \(error)")
                return
            } else {
                print("User created")
            }
        }
    }
    
    func logInExistingEmailPasswordUser(email: String, password: String, errorCallback: @escaping (() -> Void)) {
        Auth.auth().signIn(withEmail: email, password: password) { authResult, err in
            if let error = err {
                print("ERROR: signning in failed \(error)")
                errorCallback()
                return
            } else {
                print("User signed in \(authResult?.user.uid ?? "")")
            }
        }
    }
    
    func signOut() {
        do {
            try Auth.auth().signOut()
        } catch {
            print("Sign out failed: \(error)")
        }
    }
}
