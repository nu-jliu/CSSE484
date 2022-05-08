//
//  Message.swift
//  Group Chat
//
//  Created by Jingkun Liu on 5/7/22.
//

import Foundation
import Firebase

class Message {
    var sender: String
    var text: String
    var documentId: String?
    
    init(sender: String, text: String) {
        self.sender = sender
        self.text = text
    }
    
    init(snapshot doc: DocumentSnapshot) {
        self.documentId = doc.documentID
        self.sender = doc.get(Constants.MESSAGES_SENT_BY_KEY) as! String
        self.text = doc.get(Constants.MESSAGES_TEXT_KEY) as! String
    }
}
