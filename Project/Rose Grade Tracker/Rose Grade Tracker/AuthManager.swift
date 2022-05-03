//
//  AuthManager.swift
//  Rose Grade Tracker
//
//  Created by Jingkun Liu on 4/30/22.
//

import Foundation
import Firebase

class AuthManager {
    
    static let shared = AuthManager()
    
    private init() {
        
    }
    
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
    
    func signInwithRoseifreToken(_ rosefireToken: String) {
        Auth.auth().signIn(withCustomToken: rosefireToken) { res, err in
            if let err = err {
                print("Error: \(err)")
                return
            }
            
            print("Signed in using rosefire \(res!.user)")
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
