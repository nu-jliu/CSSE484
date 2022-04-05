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
        self._collectionRef = Firestore.firestore().collection(MOVIE_QUOTES_COLLECTION_PATH)
    }
    
    var latestMovieQuotes = [MovieQuote]()
    
    func startListening(changeListener: @escaping (() -> Void)) {
        // TODO: receive a changeListener
        
        let query = self._collectionRef.order(by: MOVIE_QUOTE_LAST_TOUCHED, descending: true).limit(to: 50)
        query.addSnapshotListener { snapshot, err in
            guard let documents = snapshot?.documents else {
                print("ERROR: failed to fetching documents: \(err!)")
                return
            }
            
            self.latestMovieQuotes = [MovieQuote]()
            for doc in documents {
                print("\(doc.documentID) => \(doc.data())")
                self.latestMovieQuotes.append(MovieQuote(docSnapshot: doc))
            }
            
            changeListener()
        }
    }
    
    func stopListening() {
        // TODO: remove listener
    }
    
    func add(_ mq: MovieQuote) {
        var ref: DocumentReference? = nil
        ref = self._collectionRef.addDocument(data: [
            MOVIE_QUOTE_QUOTE: mq.quote,
            MOVIE_QUOTE_MOVIE: mq.movie,
            MOVIE_QUOTE_LAST_TOUCHED: Timestamp.init()
        ]) { err in
            if let e = err {
                print("ERROR: failed to add document \(e)")
            } else {
                print("Document added: \(ref!.documentID)")
            }
        }
    }
    
    func delete(_ documentId: String) {
        self._collectionRef.document(documentId).delete() { err in
            if let err = err {
                print("ERROR: failed to detele document \(err)")
            } else {
                print("Delete document \(documentId) sucessful")
            }
        }
    }
}
