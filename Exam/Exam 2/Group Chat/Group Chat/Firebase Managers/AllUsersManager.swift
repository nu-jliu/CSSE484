//
//  AllUsersManager.swift
//  Group Chat
//
//  Created by Jingkun Liu on 5/5/22.
//

import Foundation
import Firebase

class AllUsersManger {
    
    static let shared = AllUsersManger()
    
    var emailNameMap = [String: String]()
    var _collectionRef: CollectionReference
    
    private init() {
        self._collectionRef = Firestore.firestore().collection(Constants.USERS_COLLECTION_PATH)
    }
    
    func startsListenering(changeListener: @escaping (() -> Void)) -> ListenerRegistration {
        return self._collectionRef.addSnapshotListener { querySnapshot, err in
            if let err = err {
                print("Error: \(err)")
                return
            }
            
            if let docChanges = querySnapshot?.documentChanges {
                for docChange in docChanges {
                    let doc = docChange.document
                    let email = doc.documentID
                    let firstname = doc.get(Constants.USER_FIRST_NAME) as! String
                    let lastname = doc.get(Constants.USER_LAST_NAME) as! String
                    let name = "\(firstname) \(lastname)"
                    
                    switch docChange.type {
                    case .added, .modified:
                        self.emailNameMap[email] = name
                    case .removed:
                        self.emailNameMap.removeValue(forKey: email)
                    }
                }
                
                print("User map updated")
                changeListener()
            }
        }
    }
    
    func stopListening(_ listenerRegisteration: ListenerRegistration?) {
        listenerRegisteration?.remove()
    }
}
