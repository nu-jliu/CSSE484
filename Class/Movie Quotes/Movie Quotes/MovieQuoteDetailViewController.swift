//
//  MovieQuoteDetailViewController.swift
//  Movie Quotes
//
//  Created by Jingkun Liu on 3/29/22.
//

import UIKit
import Firebase

class MovieQuoteDetailViewController: UIViewController {

    @IBOutlet weak var movieLabel: UILabel!
    @IBOutlet weak var quoteLabel: UILabel!
    
//    var movieQuote: MovieQuote!
    var movieQuoteDocumentId: String!
    var moviequoteListenerRegisteration: ListenerRegistration?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(self.showEditMovieQuoteDialog))
        
//        print("TODO: listen for the doc with docId: \(self.movieQuoteDocumentId)")
        self.updateView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.moviequoteListenerRegisteration = MovieQuoteDocumentManager.shared.startListening(for: self.movieQuoteDocumentId) {
            
            self.updateView()
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        MovieQuoteDocumentManager.shared.stopListening(self.moviequoteListenerRegisteration)
    }
    
    @objc func showEditMovieQuoteDialog() {
        print("You pressed the add button")
        
        let alertController = UIAlertController(title: "Edit a new Movie Quote", message: "", preferredStyle: .alert)
        
        // add qupte textfield
        alertController.addTextField { textField in
            textField.placeholder = "Quote"
            textField.text = MovieQuoteDocumentManager.shared.latestMovieQuote?.quote
        }
        
        alertController.addTextField { textField in
            textField.placeholder = "Movie"
            textField.text = MovieQuoteDocumentManager.shared.latestMovieQuote?.movie
        }
        
        // Cancel action
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel) { action in
            print("You pressed cancel")
        })
        
        // Edit quote action
        alertController.addAction(UIAlertAction(title: "Edit Quote", style: .default) { action in
            print("You edit quote")
            
            let quoteTextField = alertController.textFields![0] as UITextField
            let movieTextField = alertController.textFields![1] as UITextField
            print("Quote: \(quoteTextField.text!)\nMovie: \(movieTextField.text!)")
            
//            self.movieQuote.quote = quoteTextField.text!
//            self.movieQuote.movie = movieTextField.text!
            
//            self.updateView()
            
            MovieQuoteDocumentManager.shared.update(quote: quoteTextField.text!, movie: movieTextField.text!)
            self.updateView()
        })
        
        self.present(alertController, animated: true)
    }

    func updateView() {
//        self.quoteLabel.text = self.movieQuote.quote
//        self.movieLabel.text = self.movieQuote.movie
        
        if let mq = MovieQuoteDocumentManager.shared.latestMovieQuote {
            self.quoteLabel.text = mq.quote
            self.movieLabel.text = mq.movie
        }
    }

}
