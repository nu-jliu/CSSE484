//
//  Album.swift
//  Photo Buckets
//
//  Created by Jingkun Liu on 5/10/22.
//

import Foundation
import Firebase

class Album {
    var name: String
    var memberUids: [String]
    var ownerUid: String
    var documentId: String?
    
    init(members: [String], owner: String, name: String) {
        self.name = name
        self.memberUids = members
        self.ownerUid = owner
    }
    
    init(snapshot: DocumentSnapshot) {
        self.documentId = snapshot.documentID
        self.name = snapshot.get(Constants.FIREBASE_ALBUM_NAME_KEY) as? String ?? ""
        self.memberUids = snapshot.get(Constants.FIREBASE_ALBUM_MEMBER_UIDS_KEY) as? [String] ?? [String]()
        self.ownerUid = snapshot.get(Constants.FIREBASE_ALBUM_OWNER_UID_KEY) as? String ?? ""
    }
}
