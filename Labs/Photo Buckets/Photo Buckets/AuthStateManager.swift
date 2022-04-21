//
//  AuthStateManager.swift
//  Photo Buckets
//
//  Created by Jingkun Liu on 4/19/22.
//

import Foundation
import FirebaseAuth

class AuthStateManager {
    
    static let shared = AuthStateManager()
    
    private init() {
        
    }
    
    var currentUser: User? {
        Auth.auth().currentUser
    }
    
    var isSignedIn: Bool {
        self.currentUser != nil
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
            if user != nil {
                callback()
            }
        }
    }
    
    func removeObserver(_ authStateChangeHandle: AuthStateDidChangeListenerHandle?) {
        if let authHandle = authStateChangeHandle {
            Auth.auth().removeStateDidChangeListener(authHandle)
        }
    }
    
    func logInExisitingEmailPasswordUser(email: String, password: String) {
        Auth.auth().signIn(withEmail: email, password: password) { res, err in
            if let err = err {
                print("Error: \(err)")
                return
            }
            
            print("User signed in: \(res?.user.uid ?? "")")
        }
    }
    
    func signInAnonymously() {
        Auth.auth().signInAnonymously { res, err in
            if let err = err {
                print("Error: \(err)")
                return
            }
            
            print("Signed in \(res?.user.uid ?? "")")
        }
    }
    
    func signInWithRoseFire(_ rosefireToken: String) {
        Auth.auth().signIn(withCustomToken: rosefireToken) { res, err in
            if let err = err {
                print("Error: \(err)")
                return
            }
            
            print("Signed in using rosefire: \(res?.user.uid ?? "")")
        }
    }
    
    func signInWithGoogleCredential(_ credential: AuthCredential) {
        Auth.auth().signIn(with: credential) { res, err in
            if let err = err {
                print("Error: \(err)")
                return
            }
            
            print("User \(res?.user.uid ?? "") signed out")
        }
    }
}
