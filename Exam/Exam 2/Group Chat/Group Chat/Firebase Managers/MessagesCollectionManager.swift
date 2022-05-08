//
//  MessagesCollectionManager.swift
//  Group Chat
//
//  Created by Jingkun Liu on 5/7/22.
//

import Foundation
import Firebase

class MessagesCollectionManager {
    
    static let shared = MessagesCollectionManager()
    var _collectionRef: CollectionReference
    var _messageCollectionRef: CollectionReference?
    
    
    private init() {
        self._collectionRef = Firestore.firestore().collection(Constants.GROUPS_COLLECTION_PATH)
    }
    
    var latestMessages = [Message]()
    
    func startListening(for documentId: String, changeListener: @escaping (() -> Void)) -> ListenerRegistration {
        // TODO: receive a changeListener
        
        self._messageCollectionRef = self._collectionRef
            .document(documentId)
            .collection(Constants.MESSAGES_COLLECTION_PATH)
        
        let query = self._messageCollectionRef!.order(
                by: Constants.MESSAGES_SENT_ON_KEY,
                descending: false
            ).limit(to: 100)
        
        return query.addSnapshotListener { snapshot, err in
            guard let documents = snapshot?.documents else {
                print("ERROR: failed to fetching documents: \(err!)")
                return
            }
            
            self.latestMessages = [Message]()
            for doc in documents {
                let message = Message(snapshot: doc)
                //                if mq.authorUid == AuthManager.shared.currentUser?.uid || mq.documentId == "Console Data" {
                self.latestMessages.append(message)
                //                }
            }
            
            changeListener()
        }
    }
    
    func stopListening(_ listenerRegisteration: ListenerRegistration?) {
        print("Removing the collection listener ...")
        listenerRegisteration?.remove()
    }
    
    func add(_ message: Message) {
        var ref: DocumentReference? = nil
        ref = self._messageCollectionRef!
            .addDocument(data: [
                Constants.MESSAGES_SENT_BY_KEY: message.sender,
                Constants.MESSAGES_SENT_ON_KEY: Timestamp.init(),
                Constants.MESSAGES_TEXT_KEY: message.text
            ]) { err in
                if let e = err {
                    print("ERROR: failed to add document \(e)")
                } else {
                    print("Document added: \(ref!.documentID)")
                }
            }
    }
    
    func delete(_ documentId: String) {
        self._messageCollectionRef!.document(documentId).delete() { err in
            if let err = err {
                print("ERROR: failed to detele document \(err)")
            } else {
                print("Delete document \(documentId) sucessful")
            }
        }
    }
}
