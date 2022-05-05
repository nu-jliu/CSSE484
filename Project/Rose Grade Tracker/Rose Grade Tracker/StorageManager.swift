//
//  StorageManager.swift
//  Rose Grade Tracker
//
//  Created by Jingkun Liu on 5/3/22.
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
        guard let newImage = Utils.cropImageToSquare(image: image) else { return }
        
        guard let imageData = Utils.resize(image: newImage) else {
            print("Convert image to data failed")
            return
        }
        
        let photoRef = self._storageRef.child(Constants.FIRESTORE_USER_COLLECTION_PATH).child("\(uid).jpg")
//        photoRef.putData(imageData)
        
        photoRef.putData(imageData, metadata: nil) { mataData, err in
            if let err = err {
                print("ERROR: \(err)")
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
}
