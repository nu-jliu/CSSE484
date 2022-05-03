//
//  MovieQuotesTableViewController.swift
//  Movie Quotes
//
//  Created by Jingkun Liu on 3/28/22.
//

import UIKit
import Firebase

class MovieQuotesTableViewCell: UITableViewCell {
    @IBOutlet weak var quoteLabel: UILabel!
    @IBOutlet weak var movieLabel: UILabel!
}

class MovieQuotesTableViewController: UITableViewController {
    
    let movieQuoteCell = "MovieQuoteCell"
    let movieQuoteDetailSegue = "MovieQuoteDetailSegue"
    var movieQuotesListenerRegisteration: ListenerRegistration?
    
    var isShowingAllQuotes = true
    var logoutHandle: AuthStateDidChangeListenerHandle?
//    var movieQuotes = [MovieQuote]()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
//        self.navigationItem.leftBarButtonItem = self.editButtonItem
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(showAddMovieQuoteDialog)
        )
        
//        self.navigationItem.rightBarButtonItem = UIBarButtonItem(
//            title: "☰",
//            style: .plain,
//            target: self,
//            action: #selector(showMenu)
//        )
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.startListeningForMovieQuotes()
        
        // TODO: Eventual use a login
//        if AuthManager.shared.isSignedIn {
//            print("User is signed in")
//        } else {
//            print("No user, sign in anomymously")
//            AuthManager.shared.signInAnonymously()
//        }
        
//        if (!AuthManager.shared.isSignedIn) {
//            print("Oops")
//            self.navigationController?.popViewController(animated: true)
//        }
        
        self.logoutHandle = AuthManager.shared.addLogoutObserver {
            print("Oops")
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.stopListeningForMovieQuotes()
    }
    
    func startListeningForMovieQuotes() {
//        self.movieQuotesListenerRegisteration = MovieQuotesCollectionManager.shared.startListening {
//            print("The movie quotes were updated")
//
//            self.tableView.reloadData()
//        }
        
        self.movieQuotesListenerRegisteration = MovieQuotesCollectionManager.shared.startListening(filterByAuther: self.isShowingAllQuotes ? nil : AuthManager.shared.currentUser?.uid) {
            self.tableView.reloadData()
        }
    }
    
    func stopListeningForMovieQuotes() {
        MovieQuotesCollectionManager.shared.stopListening(self.movieQuotesListenerRegisteration)
    }
    
    @objc func showMenu() {
        print("TODO show action sheet")
        
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        // show only my quote
        let showOnlyMyQuoteAction = UIAlertAction(
            title: self.isShowingAllQuotes ? "Show Only My Quotes" : "Show All Quotes",
            style: .default
        ) { action in
            self.isShowingAllQuotes = !self.isShowingAllQuotes
            print("Toggle show only my quote")
            self.startListeningForMovieQuotes()
        }
        alertController.addAction(showOnlyMyQuoteAction)
        
        // sign out
        let signOutAction = UIAlertAction(title: "Sign Out", style: .default) { action in
            AuthManager.shared.signOut()
            print("sign out")
        }
        alertController.addAction(signOutAction)
        
        // add a quote
        let showAddQuoteDialogAction = UIAlertAction(title: "Add a Quote", style: .default) { action in
            self.showAddMovieQuoteDialog()
        }
        alertController.addAction(showAddQuoteDialogAction)
        
        // cancel
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true)
    }
    
    @objc func showAddMovieQuoteDialog() {
        print("You pressed the add button")
        
        let alertController = UIAlertController(title: "Create a new Movie Quote", message: "", preferredStyle: .alert)
        
        // add qupte textfield
        alertController.addTextField { textField in
            textField.placeholder = "Quote"
        }
        
        alertController.addTextField { textField in
            textField.placeholder = "Movie"
        }
        
        // Cancel action
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel) { action in
            print("You pressed cancel")
        })
        
        // Create quote action
        alertController.addAction(UIAlertAction(title: "Create Quote", style: .default) { action in
            print("You create quote")
            
            let quoteTextField = alertController.textFields![0] as UITextField
            let movieTextField = alertController.textFields![1] as UITextField
//            print("Quote: \(quoteTextField.text!)\nMovie: \(movieTextField.text!)")
            
            let mq = MovieQuote(quote: quoteTextField.text!, movie: movieTextField.text!)
//            self.movieQuotes.insert(mq, at: 0)
//            self.tableView.reloadData()
            
            // TODO: Figure out how to add the data
            MovieQuotesCollectionManager.shared.add(mq)
            
        })
        
        self.present(alertController, animated: true)
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
//        return self.movieQuotes.count
//        print("Table Count = \(MovieQuotesCollectionManager.shared.latestMovieQuotes.count)")
        
        return MovieQuotesCollectionManager.shared.latestMovieQuotes.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: self.movieQuoteCell, for: indexPath) as! MovieQuotesTableViewCell

        // Configure the cell...
//        cell.textLabel?.text = "This is row \(indexPath.row)"
//        cell.textLabel?.text = self.names[indexPath.row]
//        cell.textLabel?.text = self.movieQuotes[indexPath.row].quote
//        cell.detailTextLabel?.text = self.movieQuotes[indexPath.row].movie
        
        let mq = MovieQuotesCollectionManager.shared.latestMovieQuotes[indexPath.row]
        cell.quoteLabel.text = mq.quote
        cell.movieLabel.text = mq.movie
        return cell
    }

    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
//            self.movieQuotes.remove(at: indexPath.row)
//            self.tableView.reloadData()
            
            let mqToDelete = MovieQuotesCollectionManager.shared.latestMovieQuotes[indexPath.row]
            MovieQuotesCollectionManager.shared.delete(mqToDelete.documentId!)
        }
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        let mq = MovieQuotesCollectionManager.shared.latestMovieQuotes[indexPath.row]
        return AuthManager.shared.currentUser?.uid == mq.authorUid
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == self.movieQuoteDetailSegue {
            let mqDetailVC = segue.destination as! MovieQuoteDetailViewController
            if let indexPath = self.tableView.indexPathForSelectedRow {
                let mq = MovieQuotesCollectionManager.shared.latestMovieQuotes[indexPath.row]
                mqDetailVC.movieQuoteDocumentId = mq.documentId
            }
        }
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
}
