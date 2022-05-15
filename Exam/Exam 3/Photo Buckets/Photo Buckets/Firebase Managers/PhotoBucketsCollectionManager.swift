//
//  PhotoBucketsCollectionManager.swift
//  Photo Buckets
//
//  Created by Jingkun Liu on 4/1/22.
//

import Foundation
import Firebase
import UIKit

class PhotoBucketsCollectionManager {
    
    static let shared = PhotoBucketsCollectionManager()
    var _collectionRef: CollectionReference
    var _photosCollectionRef: CollectionReference?
    
    private init () {
        self._collectionRef  = Firestore.firestore().collection(Constants.FIREBASE_ALBUMS_COLLECTION_PATH)
    }
    
    var latestPhotos = [Photo]()
    
    func startsListening(_ onlyShowMine: Bool, for albumDocId: String, changeListener: @escaping (() -> Void)) -> ListenerRegistration {
        
        self.latestPhotos.removeAll()
        
        self._photosCollectionRef = self._collectionRef
            .document(albumDocId)
            .collection(Constants.FIREBASE_PHOTOS_COLLECTION_PATH)
            
        var query = self._photosCollectionRef!.order(by: Constants.FIREBASE_LAST_TOUCHED_KEY)
            .limit(to: 50)
        
        if let user = AuthStateManager.shared.currentUser {
            if onlyShowMine {
                query = query.whereField(Constants.FIREBASE_AUTHOR_ID_KEY, isEqualTo: user.uid)
            }
        }
        
        return query.addSnapshotListener { docSnapshot, err in
            guard let snapshot = docSnapshot else {
                print("ERROR: failed to fetch documents \(err!)")
                return
            }
            
            self.latestPhotos.removeAll()
            
            for doc in snapshot.documents {
                let photo = Photo(snapshot: doc)
                
                self.latestPhotos.append(photo)
            }
        
            changeListener()
        }
    }
    
    func stopListening(_ listenerRegisteration: ListenerRegistration?) {
        // TODO: Implement this
        listenerRegisteration?.remove()
    }
    
    func add(_ photo: Photo) -> DocumentReference {
        // TODO: Implement this
        return self._photosCollectionRef!.addDocument(data: [
            Constants.FIREBASE_PHOTO_TITLE_KEY: photo.title,
            Constants.FIREBASE_PHOTO_URL_KEY: photo.imageUrl,
            Constants.FIREBASE_LAST_TOUCHED_KEY: Timestamp.init(),
            Constants.FIREBASE_AUTHOR_ID_KEY: AuthStateManager.shared.currentUser?.uid ?? ""
        ])
    }
    
    func delete(_ docId: String) {
        // TODO: Implement this
        self._photosCollectionRef!.document(docId).delete() { err in
            if let err = err {
                print("ERROR: remove document \(docId) failed \(err)")
            } else {
                print("Remove document \(docId) successfully")
            }
        }
    }
}
