//
//  MovieQuote.swift
//  Movie Quotes
//
//  Created by Jingkun Liu on 3/28/22.
//

import Foundation
import Firebase

class MovieQuote {
    var quote: String
    var movie: String
    var documentId: String?
    
    init(quote: String, movie: String) {
        self.quote = quote
        self.movie = movie
    }
    
    init(docSnapshot: DocumentSnapshot) {
        self.documentId = docSnapshot.documentID
        let data = docSnapshot.data()
        
        self.quote = data?[MOVIE_QUOTE_QUOTE] as? String ?? ""
        self.movie = data?[MOVIE_QUOTE_MOVIE] as? String ?? ""
    }
}

