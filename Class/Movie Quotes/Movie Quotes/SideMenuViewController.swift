//
//  SideMenuViewController.swift
//  Movie Quotes
//
//  Created by Jingkun Liu on 4/21/22.
//

import UIKit

class SideMenuViewController: UIViewController {

    var tableViewController: MovieQuotesTableViewController {
        let navController = self.presentingViewController as! UINavigationController
        return navController.viewControllers.last as! MovieQuotesTableViewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func pressedEditProfile(_ sender: Any) {
        self.dismiss(animated: true)
        self.tableViewController.performSegue(
            withIdentifier: SHOW_PROFILE_SEGUE,
            sender: self.tableViewController
        )
    }
    
    @IBAction func pressedShowAllQuotes(_ sender: Any) {
        self.dismiss(animated: true)
        self.tableViewController.isShowingAllQuotes = true
        self.tableViewController.startListeningForMovieQuotes()
    }
    
    @IBAction func pressedShowMuQuotes(_ sender: Any) {
        self.dismiss(animated: true)
        self.tableViewController.isShowingAllQuotes = false
        self.tableViewController.startListeningForMovieQuotes()
    }
    
    @IBAction func pressedDeleteQuote(_ sender: Any) {
        self.dismiss(animated: true)
        self.tableViewController.isEditing = !self.tableViewController.isEditing
    }
    
    @IBAction func pressedSignOut(_ sender: Any) {
        self.dismiss(animated: true) {
            AuthManager.shared.signOut()
        }
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
