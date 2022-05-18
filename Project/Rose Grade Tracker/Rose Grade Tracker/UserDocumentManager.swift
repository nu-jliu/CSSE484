//
//  UserDocumentManager.swift
//  Rose Grade Tracker
//
//  Created by Jingkun Liu on 5/3/22.
//

import Foundation
import Firebase

class UserDocumentManager {
    
    var _latestDocument: DocumentSnapshot?
    
    static let shared = UserDocumentManager()
    var _collectionRef: CollectionReference
    
    private init() {
        self._collectionRef = Firestore.firestore().collection(Constants.FIRESTORE_USER_COLLECTION_PATH)
    }
    
    // TODO: implement create
    func addNewUserMaybe(uid: String, name: String?, photoUrl: String?) {
        // Try to get the user doc for uid
        let docRef = self._collectionRef.document(uid)
        
        docRef.getDocument { doc, err in
            if let doc = doc, doc.exists {
                print("User \(doc.documentID) exist")
                
                if doc.get(Constants.FIRESTORE_USER_CURRENT_CREDITS) == nil {
                    docRef.updateData([
                        Constants.FIRESTORE_USER_CURRENT_CREDITS: 0
                    ])
                }
                
                if doc.get(Constants.FIRESTORE_USER_CURRENT_GPA) == nil {
                    docRef.updateData([
                        Constants.FIRESTORE_USER_CURRENT_GPA: 0.0
                    ])
                }
            } else {
                print("User doc does not exist, create a new user")
                docRef.setData([
                    Constants.FIRESTORE_USER_NAME: name ?? "",
                    Constants.FIRESTORE_USER_PHOTO_URL: photoUrl ?? "",
                    Constants.FIRESTORE_USER_CURRENT_CREDITS: 0,
                    Constants.FIRESTORE_USER_CURRENT_GPA: 0.0
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
            
//            self.latestUser = User.init(docSnapshot: document)
            self._latestDocument = document
            changeListener()
        }
    }
    
    func stopListening(_ listenerRegisteration: ListenerRegistration?) {
        print("Removing the document listener ...")
        listenerRegisteration?.remove()
    }
    
    var name: String {
        if let name = self._latestDocument?.get(Constants.FIRESTORE_USER_NAME) {
            return name as! String
        }
        
        return ""
    }
    
    var photoUrl: String {
        if let photoUrl = self._latestDocument?.get(Constants.FIRESTORE_USER_PHOTO_URL) {
            return photoUrl as! String
        }
        
        return ""
    }
    
    var GPA: Double {
        if let point = self._latestDocument?.get(Constants.FIRESTORE_USER_CURRENT_GPA) {
            return point as! Double
        }
        
        return 0.0
    }
    
    var credits: Int {
        if let credit = self._latestDocument?.get(Constants.FIRESTORE_USER_CURRENT_CREDITS) {
            return credit as! Int
        }
        
        return 0
    }
    
//    func update(quote: String, movie: String) {
//        self._collectionRef.document(self.latestUser!.documentId!).updateData([
//            MOVIE_QUOTE_QUOTE: quote,
//            MOVIE_QUOTE_MOVIE: movie,
//            MOVIE_QUOTE_LAST_TOUCHED: Timestamp.init()
//        ]) { err in
//            if let err = err {
//                print("ERROR: failed to update document \(err)")
//            } else {
//                print("Update document \(self.latestUser!.documentId!) successfully")
//            }
//        }
//    }
    
    func updatePhotoUrl(photoUrl: String) {
        self._collectionRef.document(self._latestDocument!.documentID).updateData([
            Constants.FIRESTORE_USER_PHOTO_URL: photoUrl
        ]) { err in
            if let err = err {
                print("ERROR: failed to update document \(err)")
            } else {
                print("Update document \(self._latestDocument!.documentID) successfully")
            }
            
        }
    }
}
