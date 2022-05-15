//
//  AlbumsSideMenuViewController.swift
//  Photo Buckets
//
//  Created by Jingkun Liu on 5/11/22.
//

import UIKit

class AlbumsSideMenuViewController: UIViewController {
    
    var albumsTableViewController: AlbumsTableViewController {
        let navController = self.presentingViewController as! UINavigationController
        return navController.viewControllers.last as! AlbumsTableViewController
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    // MARK: - Button Actions
    
    @IBAction func deleteAlbumPressed(_ sender: Any) {
        self.dismiss(animated: true)
        self.albumsTableViewController.isEditing = !self.albumsTableViewController.isEditing
    }
    
    @IBAction func signOutPressed(_ sender: Any) {
        self.dismiss(animated: true)
        AuthStateManager.shared.signOut()
    }
}
