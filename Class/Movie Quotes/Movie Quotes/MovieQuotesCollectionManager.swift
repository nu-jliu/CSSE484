//
//  MovieQuotesCollectionManager.swift
//  Movie Quotes
//
//  Created by Jingkun Liu on 3/31/22.
//

import Foundation
import Firebase

class MovieQuotesCollectionManager {
    
    static let shared = MovieQuotesCollectionManager()
    var _collectionRef: CollectionReference
    
    private init() {
        self._collectionRef = Firestore
            .firestore()
            .collection(MOVIE_QUOTES_COLLECTION_PATH)
    }
    
    var movieQuotes = [MovieQuote]()
    
    func startListening() {
        // TODO: receive a changeListener
        
        let query = self._collectionRef
            .order(by: MOVIE_QUOTE_LAST_TOUCHED, descending: true)
            .limit(to: 50)
        query.addSnapshotListener { snapshot, err in
            guard let documents = snapshot?.documents else {
                print("ERROR: failed to fetching documents: \(err!)")
                return
            }
            
            for doc in documents {
                print("\(doc.documentID) => \(doc.data())")
            }
        }
    }
    
    func stopListening() {
        // TODO: remove listener
    }
    
    func add(_ mq: MovieQuote) {
        
    }
    
    func delete(_ documentId: String) {
        
    }
}
