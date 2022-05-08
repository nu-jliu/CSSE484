//
//  MessageDocumentManager.swift
//  Group Chat
//
//  Created by Jingkun Liu on 5/8/22.
//

import Foundation
import Firebase

class MessageDocumentManager {
    
    var latestMessage: Message?
    
    static let shared = MessageDocumentManager()
    var _collectionRef: CollectionReference
    var _documentRef: DocumentReference?
    
    private init() {
        self._collectionRef = Firestore.firestore().collection(Constants.GROUPS_COLLECTION_PATH)
    }
    
    func startListening(forGroup groupId: String, for docId: String, changeListener: @escaping (() -> Void)) -> ListenerRegistration {
        self._documentRef = self._collectionRef
            .document(groupId)
            .collection(Constants.MESSAGES_COLLECTION_PATH)
            .document(docId)
        
        return self._documentRef!.addSnapshotListener { docSnapshot, err in
                guard let document = docSnapshot else {
                    print("ERROR: failed to fetch the data \(err!)")
                    return
                }
                
                guard document.data() != nil else {
                    print("Document \(document.documentID) is empty")
                    return
                }
                
                self.latestMessage = Message(snapshot: document)
                changeListener()
            }
    }
    
    func stopListening(_ listenerRegisteration: ListenerRegistration?) {
        print("Removing the document listener ...")
        listenerRegisteration?.remove()
    }
    
    func update(text: String) {
        self._documentRef?.updateData([
            Constants.MESSAGES_TEXT_KEY: text
        ]) { err in
            if let err = err {
                print("Error: \(err)")
            } else {
                print("Update document \(self.latestMessage?.documentId ?? "") successfully")
            }
        }
    }
}
