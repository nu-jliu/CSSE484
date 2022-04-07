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
    var latestPhoto: Photo?
    
    private init() {
        self._collectionReference = Firestore.firestore().collection(Constants.FIREBASE_PHOTOS_COLLECTION_PATH)
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
            
            self.latestPhoto = Photo.init(snaphot: doc)
            changeListener()
        }
    }
    
    func stopListening(_ photoListenerRegisteration: ListenerRegistration?) {
        print("Removing photo listener registeration ...")
        photoListenerRegisteration?.remove()
        print("Photo listener removed")
    }
    
    func update(title: String, url: String) {
        self._collectionReference.document(self.latestPhoto!.documentId!).updateData([
            Constants.FIREBASE_PHOTO_TITLE_KEY: title,
            Constants.FIREBASE_PHOTO_URL_KEY: url,
            Constants.FIREBASE_LAST_TOUCHED_KEY: Timestamp.init()
        ])
    }
    
}
