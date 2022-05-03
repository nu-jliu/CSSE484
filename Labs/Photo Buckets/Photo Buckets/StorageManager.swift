//
//  StorageManager.swift
//  Photo Buckets
//
//  Created by Jingkun Liu on 4/28/22.
//

import Foundation
import Firebase
import FirebaseStorage
import UIKit

class StorageManager {
    
    static let share = StorageManager()
    var _storageRef: StorageReference
    
    private init() {
        self._storageRef = Storage.storage().reference()
    }
    
    func uploadProfilePhoto(uid: String, image: UIImage) {
        guard let imageData = PhotoUtils.resize(image: image) else {
            print("Convert image to data failed")
            return
        }
        
        let photoRef = self._storageRef.child(Constants.FIREBASE_USERS_COLLECTION_PATH).child("\(uid).jpg")
//        photoRef.putData(imageData)
        
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"
        
        photoRef.putData(imageData, metadata: metadata) { mataData, err in
            if let err = err {
                print("ERROR storage: \(err)")
                return
            }
            
//            print("Upload complete, TODO: get download url")
            photoRef.downloadURL { downloadUrl, err in
                if let err = err {
                    print("Error: \(err)")
                    return
                }
                
                print("Download url: \(downloadUrl!.absoluteString)")
                UserDocumentManager.shared.updatePhotoUrl(photoUrl: downloadUrl!.absoluteString)
            }
        }
    }
    
    func uploadPhoto(photoDoc: DocumentReference?, image: UIImage) {
        guard let imageData = PhotoUtils.resize(image: image) else {
            print("Convert image to data failed")
            return
        }
        
        let photoRef = self._storageRef.child(Constants.FIREBASE_PHOTOS_COLLECTION_PATH).child("\(photoDoc?.documentID ?? "").jpg")
//        photoRef.putData(imageData)
        
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"
        
        photoRef.putData(imageData, metadata: metadata) { mataData, err in
            if let err = err {
                print("ERROR storage: \(err)")
                return
            }
            
//            print("Upload complete, TODO: get download url")
            photoRef.downloadURL { downloadUrl, err in
                if let err = err {
                    print("Error: \(err)")
                    return
                }
                
                print("Download url: \(downloadUrl!.absoluteString)")
                
//                photoDoc?.setValue(downloadUrl?.absoluteString, forKey: Constants.FIREBASE_PHOTO_URL_KEY)
                photoDoc?.updateData([
                    Constants.FIREBASE_PHOTO_URL_KEY: downloadUrl?.absoluteString ?? ""
                ])
            }
        }
    }
    
    func deletePhoto(_ photoId: String) {
        let photoRef = self._storageRef.child(Constants.FIREBASE_PHOTOS_COLLECTION_PATH).child("\(photoId).jpg")
        
        photoRef.delete { err in
            if let err = err {
                print("Error: \(err)")
            }
        }
    }
}
