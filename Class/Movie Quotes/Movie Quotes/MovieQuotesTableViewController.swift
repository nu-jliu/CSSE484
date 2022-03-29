//
//  MovieQuotesTableViewController.swift
//  Movie Quotes
//
//  Created by Jingkun Liu on 3/28/22.
//

import UIKit

class MovieQuotesTableViewCell: UITableViewCell {
    @IBOutlet weak var quoteLabel: UILabel!
    @IBOutlet weak var movieLabel: UILabel!
}

class MovieQuotesTableViewController: UITableViewController {
    
    let movieQuoteCell = "MovieQuoteCell"
    let movieQuoteDetailSegue = "MovieQuoteDetailSegue"
//    let names = ["Dave", "Kristy", "McKinley", "Keegan", "Bowen", "Neala"]
    var movieQuotes = [MovieQuote]()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        self.navigationItem.leftBarButtonItem = self.editButtonItem
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(showAddMovieQuoteDialog))
        
        // Hardcode movie quotes
        let mq1 = MovieQuote(quote: "I'll be back", movie: "The Terminator")
        let mq2 = MovieQuote(quote: "You Adrian", movie: "Rocky")
        let mq3 = MovieQuote(quote: "You don't understand! I coulda had class. I coulda been a contender. I could've been somebody, instead of a bum, which is what I am.", movie: "On the Waterfront, 1954")
       
        self.movieQuotes.append(mq1)
        self.movieQuotes.append(mq2)
        self.movieQuotes.append(mq3)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tableView.reloadData()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
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
            print("Quote: \(quoteTextField.text!)\nMovie: \(movieTextField.text!)")
            
            let mq = MovieQuote(quote: quoteTextField.text!, movie: movieTextField.text!)
            self.movieQuotes.insert(mq, at: 0)
            self.tableView.reloadData()
            
        })
        
        self.present(alertController, animated: true)
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.movieQuotes.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: self.movieQuoteCell, for: indexPath) as! MovieQuotesTableViewCell

        // Configure the cell...
//        cell.textLabel?.text = "This is row \(indexPath.row)"
//        cell.textLabel?.text = self.names[indexPath.row]
//        cell.textLabel?.text = self.movieQuotes[indexPath.row].quote
//        cell.detailTextLabel?.text = self.movieQuotes[indexPath.row].movie
        
        cell.quoteLabel.text = self.movieQuotes[indexPath.row].quote
        cell.movieLabel.text = self.movieQuotes[indexPath.row].movie

        return cell
    }

    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            self.movieQuotes.remove(at: indexPath.row)
            self.tableView.reloadData()
        }
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == self.movieQuoteDetailSegue {
            let mqDetailVC = segue.destination as! MovieQuoteDetailViewController
            if let indexPath = self.tableView.indexPathForSelectedRow {
                mqDetailVC.movieQuote = self.movieQuotes[indexPath.row]
            }
        }
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
}
