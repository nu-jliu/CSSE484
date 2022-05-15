//
//  AlbumDocumentManager.swift
//  Photo Buckets
//
//  Created by Jingkun Liu on 5/12/22.
//

import Foundation
import Firebase

class AlbumDocumentManager {
    
    static let shared = AlbumDocumentManager()
    var _collectionReference: CollectionReference
    var latestAlbum: Album?
    
    private init() {
        self._collectionReference = Firestore.firestore().collection(Constants.FIREBASE_ALBUMS_COLLECTION_PATH)
    }
    
    func startListening(for docId: String, changeListener: @escaping (() -> Void)) -> ListenerRegistration {
        return self._collectionReference.document(docId).addSnapshotListener { docSnapshot, err in
            guard let doc = docSnapshot else {
                print("ERROR: fetch document failed")
                return
            }
            
            guard doc.data() != nil else {
                print("ERROR: document \(doc.documentID) is empty")
                return
            }
            
            self.latestAlbum = Album(snapshot: doc)
            changeListener()
        }
    }
    
    func stopListening(_ photoListenerRegisteration: ListenerRegistration?) {
        print("Removing photo listener registeration ...")
        photoListenerRegisteration?.remove()
        print("Photo listener removed")
    }
    
    func update(name: String) {
        if let docId = self.latestAlbum?.documentId {
            self._collectionReference.document(docId).updateData([
                Constants.FIREBASE_ALBUM_NAME_KEY: name
            ])
        }
    }
    
    func addMember(email: String) {
        if let uid = UsersCollectionManager.shared.userInfos.first(where: { uid, info in
            info.email == email
        })?.key {
            if var memberUids = self.latestAlbum?.memberUids {
                if !memberUids.contains(uid) {
                    memberUids.append(uid)
                    
                    if let docId = self.latestAlbum?.documentId {
                        self._collectionReference.document(docId).updateData([
                            Constants.FIREBASE_ALBUM_MEMBER_UIDS_KEY: memberUids
                        ])
                    }
                }
            }
        }
    }
    
    func removeMember(uid: String) {
        if var memberUids = self.latestAlbum?.memberUids {
            if memberUids.contains(uid) {
                memberUids.removeAll { memberUid in
                    memberUid == uid
                }
                
                self._collectionReference.document(self.latestAlbum!.documentId!).updateData([
                    Constants.FIREBASE_ALBUM_MEMBER_UIDS_KEY: memberUids
                ])
            }
        }
    }
}
