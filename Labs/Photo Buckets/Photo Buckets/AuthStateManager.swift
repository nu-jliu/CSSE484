//
//  AuthStateManager.swift
//  Photo Buckets
//
//  Created by Jingkun Liu on 4/19/22.
//

import Foundation
import Firebase

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
    
    var currentNonce: String?
    
    func addLoginObserver(callback: @escaping (() -> Void)) -> AuthStateDidChangeListenerHandle? {
        print("adding login listener ...")
        return Auth.auth().addStateDidChangeListener { auth, user in
            if user != nil {
                print("user: \(user?.uid ?? "") signed in")
                callback()
            }
        }
    }
    
    func addLogoutObserver(callback: @escaping (() -> Void)) -> AuthStateDidChangeListenerHandle? {
        print("adding logout listener ...")
        return Auth.auth().addStateDidChangeListener { auth, user in
            if user == nil {
                print("user signed out")
                callback()
            }
        }
    }
    
    func removeObserver(authStateHandle: AuthStateDidChangeListenerHandle?) {
        print("removing listener ...")
        if let authHandle = authStateHandle {
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
            
            if let user = res?.user {
                print("Google user: \(user.displayName ?? ""):\(user.uid) signed in")
            }
        }
    }
    
    func signInWithAppleCredential(_ credential: AuthCredential) {
        Auth.auth().signIn(with: credential) { res, err in
            if let err = err {
                print("Error: \(err)")
                return
            }
            
            if let user = res?.user {
                print("Apple user: \(user.displayName ?? ""):\(user.uid) signed in")
            }
        }
    }
    
    func signOut(errorCallback: @escaping (() -> Void)) {
        do {
            try Auth.auth().signOut()
        } catch {
            errorCallback()
        }
    }
}
