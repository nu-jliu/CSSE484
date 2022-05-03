//
//  Photo.swift
//  Photo
//
//  Created by Jingkun Liu on 4/1/22.
//

import Foundation
import UIKit
import Firebase

class Photo {
    
    var title: String
    var imageUrl: String
    var documentId: String?
    var authorId: String?
    
    init(title: String, imageUrl: String) {
        self.title = title
        self.imageUrl = imageUrl
    }
    
    init(snaphot: DocumentSnapshot) {
        self.documentId = snaphot.documentID
        let data = snaphot.data()
        
        self.title = data?[Constants.FIREBASE_PHOTO_TITLE_KEY] as? String ?? ""
        self.imageUrl = data?[Constants.FIREBASE_PHOTO_URL_KEY] as? String ?? ""
        self.authorId = data?[Constants.FIREBASE_AUTHOR_ID_KEY] as? String ?? ""
    }
}
