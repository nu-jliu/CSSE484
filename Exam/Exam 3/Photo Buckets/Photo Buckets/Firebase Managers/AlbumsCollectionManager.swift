//
//  AlbumsCollectionManager.swift
//  Photo Buckets
//
//  Created by Jingkun Liu on 5/10/22.
//

import Foundation
import Firebase
import UIKit

class AlbumsCollectionManager {
    
    static let shared = AlbumsCollectionManager()
    var _collectionRef: CollectionReference
    
    private init () {
        self._collectionRef  = Firestore.firestore().collection(Constants.FIREBASE_ALBUMS_COLLECTION_PATH)
    }
    
    var latestAlbums = [Album]()
    
    func startsListening(changeListener: @escaping (() -> Void)) -> ListenerRegistration? {
        
        var query = self._collectionRef.order(by: Constants.FIREBASE_ALBUM_CREATED_KEY, descending: false).limit(to: 50)
        
        if let uid = AuthStateManager.shared.currentUser?.uid {
            query = query.whereField(Constants.FIREBASE_ALBUM_MEMBER_UIDS_KEY, arrayContains: uid)
        }
        
        return query.addSnapshotListener { docSnapshot, err in
            guard let snapshot = docSnapshot else {
                print("ERROR: failed to fetch documents \(err!)")
                return
            }
            
            self.latestAlbums.removeAll()
            for doc in snapshot.documents {
                self.latestAlbums.append(Album(snapshot: doc))
            }
            
            changeListener()
        }
    }
    
    func stopListening(_ listenerRegisteration: ListenerRegistration?) {
        listenerRegisteration?.remove()
    }
    
    func add(_ album: Album) {
        self._collectionRef.addDocument(data: [
            Constants.FIREBASE_ALBUM_CREATED_KEY: Timestamp.init(),
            Constants.FIREBASE_ALBUM_MEMBER_UIDS_KEY: album.memberUids,
            Constants.FIREBASE_ALBUM_NAME_KEY: album.name,
            Constants.FIREBASE_ALBUM_OWNER_UID_KEY: album.ownerUid
        ])
    }
    
    func delete(_ docId: String) {
        self._collectionRef.document(docId).delete() { err in
            if let err = err {
                print("ERROR: remove document \(docId) failed \(err)")
            } else {
                print("Remove document \(docId) successfully")
            }
        }
    }
}
