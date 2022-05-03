//
//  MovieQuoteDocumentManager.swift
//  Movie Quotes
//
//  Created by Jingkun Liu on 3/31/22.
//

import Foundation
import Firebase

class MovieQuoteDocumentManager {
    
    var latestMovieQuote: MovieQuote?
    
    static let shared = MovieQuoteDocumentManager()
    var _collectionRef: CollectionReference
    
    private init() {
        self._collectionRef = Firestore.firestore().collection(MOVIE_QUOTES_COLLECTION_PATH)
    }
    
    func startListening(for documentId: String, changeListener: @escaping (() -> Void)) -> ListenerRegistration {
        return self._collectionRef.document(documentId).addSnapshotListener { docSnapshot, err in
            guard let document = docSnapshot else {
                print("ERROR: failed to fetch the data \(err!)")
                return
            }
            
            guard document.data() != nil else {
                print("Document \(document.documentID) is empty")
                return
            }
            
            self.latestMovieQuote = MovieQuote.init(docSnapshot: document)
            changeListener()
        }
    }
    
    func stopListening(_ listenerRegisteration: ListenerRegistration?) {
        print("Removing the document listener ...")
        listenerRegisteration?.remove()
    }
    
    func update(quote: String, movie: String) {
        self._collectionRef.document(self.latestMovieQuote!.documentId!).updateData([
            MOVIE_QUOTE_QUOTE: quote,
            MOVIE_QUOTE_MOVIE: movie,
            MOVIE_QUOTE_LAST_TOUCHED: Timestamp.init()
        ]) { err in
            if let err = err {
                print("ERROR: failed to update document \(err)")
            } else {
                print("Update document \(self.latestMovieQuote!.documentId!) successfully")
            }
        }
    }
}
