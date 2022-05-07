//
//  MembersListManager.swift
//  Group Chat
//
//  Created by Jingkun Liu on 5/5/22.
//

import Foundation
import Firebase

class MembersListManager {
    var latestGroup: Group?
    
    static let shared = MembersListManager()
    var _collectionRef: CollectionReference
    var _usersCollectionRef: CollectionReference
    
    private init() {
        self._collectionRef = Firestore.firestore().collection(Constants.GROUPS_COLLECTION_PATH)
        self._usersCollectionRef = Firestore.firestore().collection(Constants.USERS_COLLECTION_PATH)
    }
    
    func startListening(for documentId: String, changeListener: @escaping (() -> Void)) -> ListenerRegistration {
        return self._collectionRef.document(documentId).addSnapshotListener { docSnapshot, err in
            guard let document = docSnapshot else {
                print("ERROR: failed to fetch the data \(err!)")
                return
            }
            
            guard document.data() != nil else {
                print("Document \(document.documentID) is empty")
                return
            }
            
            self.latestGroup = Group(snapshot: document)
            changeListener()
        }
    }
    
    func stopListening(_ listenerRegisteration: ListenerRegistration?) {
        print("Removing the document listener ...")
        listenerRegisteration?.remove()
    }
    
    func addMember(emails: [String], errorCallback: @escaping ((_ message: String) -> Void)) {
        if var memberEmails = self.latestGroup?.memberEmails {
            for email in emails {
                if AllUsersManger.shared.emailNameMap.keys.contains(email) {
                    if self.latestGroup?.ownerEmail != email {
                        if !memberEmails.contains(email) {
                            memberEmails.append(email)
                        } else {
                            errorCallback("User \(email) is already a member")
                        }
                    } else {
                        errorCallback("User \(email) is a owner")
                    }
                } else {
                    errorCallback("User \(email) does not exist")
                }
            }
            
            if let docId = self.latestGroup?.documentId {
                self._collectionRef.document(docId).updateData([
                    Constants.GROUPS_MEMBER_EMAILS_KEY: memberEmails
                ])
            }
        }
    }
    
    func updateGroup(newName name: String) {
        self._collectionRef.document(self.latestGroup!.documentId!).updateData([
            Constants.GROUPS_NAME_KEY: name
        ])
    }
    
    func removeMember(email: String) {
        if email != self.latestGroup?.ownerEmail {
            if var memberEmails = self.latestGroup?.memberEmails {
                memberEmails.removeAll { memberEmail in
                    memberEmail == email
                }
                
                if let docId = self.latestGroup?.documentId {
                    self._collectionRef.document(docId).updateData([
                        Constants.GROUPS_MEMBER_EMAILS_KEY: memberEmails
                    ])
                }
            }
        }
    }
}
