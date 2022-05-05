//
//  UserDocumentManager.swift
//  Group Chat
//
//  Created by Jingkun Liu on 5/5/22.
//

import Foundation
import Firebase

class UserDocumentManager {
    
    var _latestDocument: DocumentSnapshot?
    
    static let shared = UserDocumentManager()
    var _collectionRef: CollectionReference
    
    private init() {
        self._collectionRef = Firestore.firestore().collection(Constants.USERS_COLLECTION_PATH)
    }
    
    // TODO: implement create
    func addNewUserMaybe(email: String, firstName: String?, lastName: String?) {
        // Try to get the user doc for uid
        let docRef = self._collectionRef.document(email)
        
        docRef.getDocument { doc, err in
            if let doc = doc, doc.exists {
                print("User with email: \(doc.documentID) exist")
            } else {
                print("User doc does not exist, create a new user")
                docRef.setData([
                    Constants.USER_FIRST_NAME: firstName ?? "",
                    Constants.USER_LAST_NAME: lastName ?? ""
                ])
            }
        }
    }
    
    func startListening(for documentId: String, changeListener: @escaping (() -> Void)) -> ListenerRegistration {
        return self._collectionRef.document(documentId).addSnapshotListener { docSnapshot, err in
            self._latestDocument = nil
            guard let document = docSnapshot else {
                print("ERROR: failed to fetch the data \(err!)")
                return
            }
            
            guard document.data() != nil else {
                print("Document \(document.documentID) is empty")
                return
            }
            
            self._latestDocument = document
            changeListener()
        }
    }
    
    func stopListening(_ listenerRegisteration: ListenerRegistration?) {
        print("Removing the document listener ...")
        listenerRegisteration?.remove()
    }
    
    var firstName: String {
        if let firstName = self._latestDocument?.get(Constants.USER_FIRST_NAME) {
            return firstName as! String
        }
        
        return ""
    }
    
    var lastName: String {
        if let lastName = self._latestDocument?.get(Constants.USER_LAST_NAME) {
            return lastName as! String
        }
        
        return ""
    }
        
    func updateName(first: String, last: String) {
        self._collectionRef.document(self._latestDocument!.documentID).updateData([
            Constants.USER_FIRST_NAME: first,
            Constants.USER_LAST_NAME: last
        ]) { err in
            if let err = err {
                print("ERROR: failed to update document \(err)")
            } else {
                print("Update document \(self._latestDocument!.documentID) successfully")
            }
            
        }
    }
}
