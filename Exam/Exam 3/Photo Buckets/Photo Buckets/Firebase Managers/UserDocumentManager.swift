//
//  UserDocumentManager.swift
//  Photo Buckets
//
//  Created by Jingkun Liu on 4/28/22.
//

import Foundation
import Firebase

class UserDocumentManager {
    
    var _latestDocument: DocumentSnapshot?
    
    static let shared = UserDocumentManager()
    var _collectionRef: CollectionReference
    
    private init() {
        self._collectionRef = Firestore.firestore().collection(Constants.FIREBASE_USERS_COLLECTION_PATH)
    }
    
    // TODO: implement create
    func addNewUserMaybe(uid: String, name: String?, email: String?, photoUrl: String?) {
        // Try to get the user doc for uid
        let docRef = self._collectionRef.document(uid)
        
        docRef.getDocument { doc, err in
            if let doc = doc, doc.exists {
                print("User \(doc.documentID) exist")
                
                if let name = name {
                    let username = doc.get(Constants.FIREBASE_USER_NAME_KEY) as? String ?? ""
                    if username.isEmpty {
                        docRef.updateData([
                            Constants.FIREBASE_USER_NAME_KEY: name
                        ])
                    }
                }
                
                if let email = email {
                    let useremail = doc.get(Constants.FIREBASE_USER_EMAIL_KEY) as? String ?? ""
                    if useremail.isEmpty {
                        docRef.updateData([
                            Constants.FIREBASE_USER_EMAIL_KEY: email
                        ])
                    }
                }
            } else {
                print("User doc does not exist, create a new user")
                docRef.setData([
                    Constants.FIREBASE_USER_NAME_KEY: name ?? "",
                    Constants.FIREBASE_USER_PHOTO_URL_KEY: photoUrl ?? ""
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
        if let name = self._latestDocument?.get(Constants.FIREBASE_USER_NAME_KEY) {
            return name as! String
        }
        
        return ""
    }
    
    var photoUrl: String {
        if let photoUrl = self._latestDocument?.get(Constants.FIREBASE_USER_PHOTO_URL_KEY) {
            return photoUrl as! String
        }
        
        return ""
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
    
    func updateName(name: String) {
        self._collectionRef.document(self._latestDocument!.documentID).updateData([
            Constants.FIREBASE_USER_NAME_KEY: name
        ]) { err in
            if let err = err {
                print("ERROR: failed to update document \(err)")
            } else {
                print("Update document \(self._latestDocument!.documentID) successfully")
            }
            
        }
    }
    
    func updatePhotoUrl(photoUrl: String) {
        self._collectionRef.document(self._latestDocument!.documentID).updateData([
            Constants.FIREBASE_USER_PHOTO_URL_KEY: photoUrl
        ]) { err in
            if let err = err {
                print("ERROR: failed to update document \(err)")
            } else {
                print("Update document \(self._latestDocument!.documentID) successfully")
            }
            
        }
    }
}

