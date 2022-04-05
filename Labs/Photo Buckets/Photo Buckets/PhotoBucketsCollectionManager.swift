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
    var _collectionSnapshotListener: ListenerRegistration?
    
    private init () {
        self._collectionRef  = Firestore.firestore().collection(Constants.FIREBASE_PHOTOS_COLLECTION_PATH)
    }
    
    var latestPhotos = [Photo]()
    
    func startsListening(changeListener: @escaping (() -> Void)) {
        
        self.latestPhotos.removeAll()
        
        let query = self._collectionRef.order(by: Constants.FIREBASE_LAST_TOUCHED_KEY).limit(to: 50)
        
        self._collectionSnapshotListener = query.addSnapshotListener { docSnapshot, err in
            guard let snapshot = docSnapshot else {
                print("ERROR: failed to fetch documents \(err!)")
                return
            }
            
            snapshot.documentChanges.forEach { docChange in
                let docSnapshot = docChange.document
                
                switch docChange.type {
                case .added:
                    print("New Photo: \(docSnapshot.data())")
                    self.latestPhotos.insert(Photo(snaphot: docSnapshot), at: 0)
                    
                case .modified:
                    print("Modified Photo: \(docSnapshot.data())")
                    if let modifiedIndex = self.latestPhotos.firstIndex(where: { photo in
                        photo.documentId == docSnapshot.documentID
                    }) {
                        self.latestPhotos[modifiedIndex] = Photo(snaphot: docSnapshot)
                    }
                    
                case .removed:
                    print("Removed Photo: \(docSnapshot.data())")
                    if let removedIndex = self.latestPhotos.firstIndex(where: { photo in
                        photo.documentId == docSnapshot.documentID
                    }) {
                        self.latestPhotos.remove(at: removedIndex)
                    }
                }
            }
        
            changeListener()
        }
    }
    
    func stopListening() {
        // TODO: Implement this
        self._collectionSnapshotListener?.remove()
    }
    
    func add(_ photo: Photo) {
        // TODO: Implement this
        self._collectionRef.addDocument(data: [
            Constants.FIREBASE_PHOTO_TITLE_KEY: photo.title,
            Constants.FIREBASE_PHOTO_URL_KEY: photo.imageUrl,
            Constants.FIREBASE_LAST_TOUCHED_KEY: Timestamp.init()
        ])
    }
    
    func delete(_ docId: String) {
        // TODO: Implement this
    }
}
