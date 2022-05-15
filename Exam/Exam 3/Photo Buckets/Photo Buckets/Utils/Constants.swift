//
//  Constants.swift
//  Photo Buckets
//
//  Created by Jingkun Liu on 4/1/22.
//

import Foundation

class Constants {
    // Firebase Photos
    static let FIREBASE_PHOTOS_COLLECTION_PATH = "photos"
    static let FIREBASE_PHOTO_TITLE_KEY = "Title"
    static let FIREBASE_PHOTO_URL_KEY = "URL"
    static let FIREBASE_LAST_TOUCHED_KEY = "lastTouched"
    static let FIREBASE_AUTHOR_ID_KEY = "authorID"
    
    // Firebase Users
    static let FIREBASE_USERS_COLLECTION_PATH = "users"
    static let FIREBASE_USER_NAME_KEY = "name"
    static let FIREBASE_USER_PHOTO_URL_KEY = "photoUrl"
    static let FIREBASE_USER_EMAIL_KEY = "email"
    
    // Firebase Albums
    static let FIREBASE_ALBUMS_COLLECTION_PATH = "albums"
    static let FIREBASE_ALBUM_CREATED_KEY = "created"
    static let FIREBASE_ALBUM_MEMBER_UIDS_KEY = "memberUids"
    static let FIREBASE_ALBUM_NAME_KEY = "name"
    static let FIREBASE_ALBUM_OWNER_UID_KEY = "ownerUid"
    
    static let ROSEFIRE_REGISTRY_TOKEN = "139851b6-4238-47b1-84b7-1bf82c66530f"
    
    // Segue identifier
    static let PHOTO_LIST_SEGUE = "photosListSegue"
    static let SHOW_PROFILE_SEGUE = "showProfileSegue"
    static let PHOTO_BUCKET_DETAIL_SEGUE = "PhotoBucketDetailSegue"
    static let ALBUMS_LIST_SEGUE = "albumsListSegue"
    static let SHOW_MEMBERS_LIST_SEGUE = "showMembersListSegue"
    
    // Cell identifier
    static let ALBUMS_CELL_IDENTIFIER = "AlbumnCell"
    static let PHOTO_BUCKET_CELL_IDENTIFIER = "PhotoBucketCell"
    static let MEMBER_CELL_IDENTIFIER = "MemberCell"
}
