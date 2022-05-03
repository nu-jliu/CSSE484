//
//  SideMenuViewController.swift
//  Photo Buckets
//
//  Created by Jingkun Liu on 4/28/22.
//

import UIKit

class SideMenuViewController: UIViewController {

    var tableViewController: PhotoBucketsTableViewController {
        let navController = self.presentingViewController as! UINavigationController
        return navController.viewControllers.last as! PhotoBucketsTableViewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func editProfilePressed(_ sender: Any) {
        self.dismiss(animated: true)
        self.tableViewController.performSegue(
            withIdentifier: Constants.SHOW_PROFILE_SEGUE,
            sender: self.tableViewController
        )
    }
    
    @IBAction func showAllPhotosPressed(_ sender: Any) {
        self.dismiss(animated: true)
        self.tableViewController.showOnlyMyPhoto = false
        self.tableViewController.startListeningForPhotots()
    }
    
    @IBAction func showMyPhotosPressed(_ sender: Any) {
        self.dismiss(animated: true)
        self.tableViewController.showOnlyMyPhoto = true
        self.tableViewController.startListeningForPhotots()
    }
    
    @IBAction func deletePhotosPressed(_ sender: Any) {
        self.dismiss(animated: true)
        self.tableViewController.isEditing = !self.tableViewController.isEditing
    }
    
    @IBAction func signOutPressed(_ sender: Any) {
        self.dismiss(animated: true)
        AuthStateManager.shared.signOut {
//            self.dismiss(animated: true)
            print("Sign out complete")
        }
    }
}
