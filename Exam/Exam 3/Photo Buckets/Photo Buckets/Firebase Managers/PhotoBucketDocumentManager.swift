//
//  PhotoBucketDocumentManager.swift
//  Photo Buckets
//
//  Created by Jingkun Liu on 4/1/22.
//

import Foundation
import Firebase

class PhotoBucketDocumentManager {
    
    static let shared = PhotoBucketDocumentManager()
    var _collectionReference: CollectionReference
    var _photosCollectionRef: CollectionReference?
    var latestPhoto: Photo?
    
    private init() {
        self._collectionReference = Firestore.firestore().collection(Constants.FIREBASE_ALBUMS_COLLECTION_PATH)
    }
    
    func startListening(for docId: String, onAlbum albumId: String, changeListener: @escaping (() -> Void)) -> ListenerRegistration? {
        self._photosCollectionRef = self._collectionReference
            .document(albumId)
            .collection(Constants.FIREBASE_PHOTOS_COLLECTION_PATH)
            
        return self._photosCollectionRef?.document(docId)
            .addSnapshotListener { docSnapshot, err in
            guard let doc = docSnapshot else {
                print("ERROR: fetch document failed")
                return
            }
            
            guard doc.data() != nil else {
                print("ERROR: document \(doc.documentID) is empty")
                return
            }
            
            self.latestPhoto = Photo(snapshot: doc)
            changeListener()
        }
    }
    
    func stopListening(_ photoListenerRegisteration: ListenerRegistration?) {
        print("Removing photo listener registeration ...")
        photoListenerRegisteration?.remove()
        print("Photo listener removed")
    }
    
    func update(title: String) {
        if let docId = self.latestPhoto?.documentId {
            self._photosCollectionRef!.document(docId).updateData([
                Constants.FIREBASE_PHOTO_TITLE_KEY: title,
                Constants.FIREBASE_LAST_TOUCHED_KEY: Timestamp.init()
            ])
        }
    }
    
    func update(url: String) {
        if let docId = self.latestPhoto?.documentId {
            self._photosCollectionRef!.document(docId).updateData([
                Constants.FIREBASE_PHOTO_URL_KEY: url,
                Constants.FIREBASE_LAST_TOUCHED_KEY: Timestamp.init()
            ])
        }
    }
    
}
