//
//  UsersCollectionManager.swift
//  Photo Buckets
//
//  Created by Jingkun Liu on 5/10/22.
//

import Foundation
import Firebase

class UsersCollectionManager {
    
    static let shared = UsersCollectionManager()
    
    var _collectionRef: CollectionReference
    var userInfos = [String: (name: String, email: String)]()
    
    private init() {
        self._collectionRef = Firestore.firestore().collection(Constants.FIREBASE_USERS_COLLECTION_PATH)
    }
    
    func startsListening(changeCallback: @escaping (() -> Void)) -> ListenerRegistration? {
        self.userInfos.removeAll()
        
        return self._collectionRef.addSnapshotListener { querySnapshot, err in
            if let err = err {
                print("User collection error: \(err)")
                return
            }
            
            if let docChanges = querySnapshot?.documentChanges {
                docChanges.forEach { docChange in
                    let doc = docChange.document
                    let uid = doc.documentID
                    let name = doc.get(Constants.FIREBASE_USER_NAME_KEY) as? String ?? ""
                    let email = doc.get(Constants.FIREBASE_USER_EMAIL_KEY) as? String ?? ""
                    
                    switch docChange.type {
                    case .added, .modified:
                        self.userInfos[uid] = (name, email)
                    case .removed:
                        self.userInfos.removeValue(forKey: uid)
                    }
                }
            }
            
            changeCallback()
        }
    }
    
    func stopListeneing(_ listenerRegisteration: ListenerRegistration?) {
        listenerRegisteration?.remove()
    }
}
