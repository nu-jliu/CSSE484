//
//  SideMenuViewController.swift
//  Photo Buckets
//
//  Created by Jingkun Liu on 4/28/22.
//

import UIKit

class SideMenuViewController: UIViewController {
    
    var tableViewController: PhotoBucketsTableViewController? {
        let navController = self.presentingViewController as! UINavigationController
        return navController.viewControllers.last as? PhotoBucketsTableViewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func showAllPhotosPressed(_ sender: Any) {
        self.dismiss(animated: true)
        self.tableViewController?.showOnlyMyPhoto = false
        self.tableViewController?.startListeningForPhotots()
    }
    
    @IBAction func showMyPhotosPressed(_ sender: Any) {
        self.dismiss(animated: true)
        self.tableViewController?.showOnlyMyPhoto = true
        self.tableViewController?.startListeningForPhotots()
    }
    
    @IBAction func deletePhotosPressed(_ sender: Any) {
        self.dismiss(animated: true)
        if let tableViewController = self.tableViewController {
            tableViewController.isEditing = !tableViewController.isEditing
        }
    }
    
    @IBAction func backToAlbumsPressed(_ sender: Any) {
        self.dismiss(animated: true)
        self.tableViewController?
            .navigationController?
            .popViewController(animated: true)
    }
}
