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
    
    @IBOutlet weak var authorBoxStackView: UIStackView!
    @IBOutlet weak var authorProfileImageView: UIImageView!
    @IBOutlet weak var authorNameLabel: UILabel!
    
    var movieQuoteDocumentId: String!
    
    var moviequoteListenerRegisteration: ListenerRegistration?
    var userListenerRegisteration: ListenerRegistration?
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(self.showEditMovieQuoteDialog))
//        self.showOrHideButton()
//
//        self.updateView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.authorBoxStackView.isHidden = true
        self.moviequoteListenerRegisteration = MovieQuoteDocumentManager.shared.startListening(
            for: self.movieQuoteDocumentId
        ) {
            print("start listening for document by \(MovieQuoteDocumentManager.shared.latestMovieQuote!.authorUid!)")
            self.updateView()
            self.showOrHideButton()
            
            // Start listening for user (author of the quote)
            if let authorUid = MovieQuoteDocumentManager.shared.latestMovieQuote?.authorUid {
                UserDocumentManager.shared.stopListening(self.userListenerRegisteration)
                self.userListenerRegisteration = UserDocumentManager.shared.startListening(for: authorUid) {
                    self.updateAuthorBox()
                }
            }
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        MovieQuoteDocumentManager.shared.stopListening(self.moviequoteListenerRegisteration)
        UserDocumentManager.shared.stopListening(self.userListenerRegisteration)
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

    func showOrHideButton() {
        
        print("Current User: \(AuthManager.shared.currentUser?.uid ?? ""), quote user: \(MovieQuoteDocumentManager.shared.latestMovieQuote?.authorUid ?? "")")
        if AuthManager.shared.currentUser?.uid == MovieQuoteDocumentManager.shared.latestMovieQuote?.authorUid {
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(
                barButtonSystemItem: .edit,
                target: self,
                action: #selector(showEditMovieQuoteDialog)
            )
        }
    }
    
    func updateView() {
//        self.quoteLabel.text = self.movieQuote.quote
//        self.movieLabel.text = self.movieQuote.movie
        
        if let mq = MovieQuoteDocumentManager.shared.latestMovieQuote {
            self.quoteLabel.text = mq.quote
            self.movieLabel.text = mq.movie
        }
        

    }

    func updateAuthorBox() {
        print("TODO: update the author box with name: \(UserDocumentManager.shared.name)")
        print("TODO: update the author box with photoUrl: \(UserDocumentManager.shared.photoUrl)")
        
        self.authorBoxStackView.isHidden = UserDocumentManager.shared.name.isEmpty || UserDocumentManager.shared.photoUrl.isEmpty
        
        if !UserDocumentManager.shared.name.isEmpty {
            self.authorNameLabel.text = UserDocumentManager.shared.name
        }
        
        if !UserDocumentManager.shared.photoUrl.isEmpty {
            ImageUtils.load(imageView: self.authorProfileImageView, from: UserDocumentManager.shared.photoUrl)
        }
    }
}
