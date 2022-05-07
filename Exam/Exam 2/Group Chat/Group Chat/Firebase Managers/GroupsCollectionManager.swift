//
//  GroupsCollectionManager.swift
//  Group Chat
//
//  Created by Jingkun Liu on 5/5/22.
//

import Foundation
import Firebase

class GroupsCollectionManager {
    
    static let shared = GroupsCollectionManager()
    var _collectionRef: CollectionReference
    
    private init() {
        self._collectionRef = Firestore.firestore().collection(Constants.GROUPS_COLLECTION_PATH)
    }
    
    var latestGroups = [Group]()
    
    func startListening(changeListener: @escaping (() -> Void)) -> ListenerRegistration {
        let query = self._collectionRef.order(
            by: Constants.GROUPS_CREATED_ON_KEY,
            descending: false
        ).limit(to: 50)
        
        return query.addSnapshotListener { snapshot, err in
            guard let documents = snapshot?.documents else {
                print("ERROR: failed to fetching documents: \(err!)")
                return
            }
            
            self.latestGroups = [Group]()
            
            for doc in documents {
                let group = Group(snapshot: doc)
                
                if group.memberEmails.contains(AuthStateManager.shared.currentUser?.email ?? "") {
                    self.latestGroups.append(group)
                }
            }
            
            changeListener()
        }
    }
    
    func stopListening(_ listenerRegisteration: ListenerRegistration?) {
        print("Removing the collection listener ...")
        listenerRegisteration?.remove()
    }
    
    func add(_ group: Group) {
        var ref: DocumentReference? = nil
        ref = self._collectionRef.addDocument(data: [
            Constants.GROUPS_CREATED_ON_KEY: Timestamp.init(),
            Constants.GROUPS_MEMBER_EMAILS_KEY: group.memberEmails,
            Constants.GROUPS_NAME_KEY: group.name,
            Constants.GROUPS_OWNER_EMAIL_KEY: group.ownerEmail
        ]) { err in
            if let e = err {
                print("ERROR: failed to add document \(e)")
            } else {
                print("Document added: \(ref!.documentID)")
            }
        }
    }
    
    func delete(_ documentId: String) {
        self._collectionRef.document(documentId).delete() { err in
            if let err = err {
                print("ERROR: failed to detele document \(err)")
            } else {
                print("Delete document \(documentId) sucessful")
            }
        }
    }
}
