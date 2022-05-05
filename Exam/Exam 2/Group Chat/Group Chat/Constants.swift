//
//  Constants.swift
//  Group Chat
//
//  Created by Jingkun Liu on 5/5/22.
//

import Foundation

class Constants {
    // users
    static let USERS_COLLECTION_PATH = "users"
    static let USER_FIRST_NAME = "firstName"
    static let USER_LAST_NAME = "lastName"
    
    // groups
    static let GROUPS_COLLECTION_PATH = "groups"
    static let GROUPS_CREATED_ON_KEY = "created"
    static let GROUPS_MEMBER_EMAILS_KEY = "memberEmails"
    static let GROUPS_NAME_KEY = "name"
    static let GROUPS_OWNER_EMAIL_KEY = "ownerEmail"
    
    // segue
    static let SHOW_LIST_SEGUE = "showListSegue"
}
