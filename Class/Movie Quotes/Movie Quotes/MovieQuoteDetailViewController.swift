//
//  MovieQuoteDetailViewController.swift
//  Movie Quotes
//
//  Created by Jingkun Liu on 3/29/22.
//

import UIKit

class MovieQuoteDetailViewController: UIViewController {

    @IBOutlet weak var movieLabel: UILabel!
    @IBOutlet weak var quoteLabel: UILabel!
    
    var movieQuote: MovieQuote!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(self.showEditMovieQuoteDialog))
        
        self.updateView()
    }
    
    @objc func showEditMovieQuoteDialog() {
        print("You pressed the add button")
        
        let alertController = UIAlertController(title: "Edit a new Movie Quote", message: "", preferredStyle: .alert)
        
        // add qupte textfield
        alertController.addTextField { textField in
            textField.placeholder = "Quote"
            textField.text = self.movieQuote.quote
        }
        
        alertController.addTextField { textField in
            textField.placeholder = "Movie"
            textField.text = self.movieQuote.movie
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
            
            self.movieQuote.quote = quoteTextField.text!
            self.movieQuote.movie = movieTextField.text!
            
            self.updateView()
        })
        
        self.present(alertController, animated: true)
    }

    func updateView() {
        self.quoteLabel.text = self.movieQuote.quote
        self.movieLabel.text = self.movieQuote.movie
    }

}
