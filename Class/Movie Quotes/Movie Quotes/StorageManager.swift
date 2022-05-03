//
//  StorageManager.swift
//  Movie Quotes
//
//  Created by Jingkun Liu on 4/26/22.
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
        guard let imageData = ImageUtils.resize(image: image) else {
            print("Convert image to data failed")
            return
        }
        
        let photoRef = self._storageRef.child(USERS_COLLECTION_PATH).child("\(uid).jpg")
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
