//
//  AlbumsTableViewController.swift
//  Photo Buckets
//
//  Created by Jingkun Liu on 5/10/22.
//

import UIKit
import Firebase

class AlbumTableViewCell: UITableViewCell {
    @IBOutlet weak var albumNameLabel: UILabel!
    @IBOutlet weak var showMembersButton: UIButton!
}

class AlbumsTableViewController: UITableViewController {
    
    var albumsListenerRegisteration: ListenerRegistration?
    var logoutHandle: AuthStateDidChangeListenerHandle?

    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(self.showAddDialog)
        )
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.albumsListenerRegisteration = AlbumsCollectionManager.shared.startsListening {
            self.tableView.reloadData()
        }
        
        self.logoutHandle = AuthStateManager.shared.addLogoutObserver {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        AlbumsCollectionManager.shared.stopListening(self.albumsListenerRegisteration)
        AuthStateManager.shared.removeObserver(authStateHandle: self.logoutHandle)
    }
    
    // MARK: - Action Buttons
    
    @objc func showAddDialog() {
        let alertController = UIAlertController(
            title: "Add a Album",
            message: "Please Enter Group Name",
            preferredStyle: .alert
        )
        
        alertController.addTextField { textfield in
            textfield.placeholder = "Album Name"
        }
        
        alertController.addAction(UIAlertAction(
            title: "Add Album",
            style: .default
        ) { action in
            let name = alertController.textFields?[0].text ?? ""
            
            if let uid = AuthStateManager.shared.currentUser?.uid {
                let album = Album(
                    members: [uid],
                    owner: uid,
                    name: name
                )
                
                AlbumsCollectionManager.shared.add(album)
            }
        })
        
        alertController.addAction(UIAlertAction(
            title: "Cancel",
            style: .cancel
        ))
        
        self.present(alertController, animated: true)
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        AlbumsCollectionManager.shared.latestAlbums.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: Constants.ALBUMS_CELL_IDENTIFIER,
            for: indexPath
        ) as! AlbumTableViewCell

        // Configure the cell...
        let album = AlbumsCollectionManager.shared.latestAlbums[indexPath.row]
        cell.albumNameLabel.text = album.name
        cell.showMembersButton.tag = indexPath.row
        
        return cell
    }
    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        let album = AlbumsCollectionManager.shared.latestAlbums[indexPath.row]
        return album.ownerUid == AuthStateManager.shared.currentUser?.uid
    }
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            if let docId = AlbumsCollectionManager.shared.latestAlbums[indexPath.row].documentId {
                AlbumsCollectionManager.shared.delete(docId)
            }
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == Constants.SHOW_MEMBERS_LIST_SEGUE {
            let membersTableVC = segue.destination as! AlbumMembersTableViewController
            if let memberButton = sender as? UIButton {
                let row = memberButton.tag
                
                let album = AlbumsCollectionManager.shared.latestAlbums[row]
                membersTableVC.albumDocumentId = album.documentId
            }
        } else if segue.identifier == Constants.PHOTO_LIST_SEGUE {
            let photosTableVC = segue.destination as! PhotoBucketsTableViewController
            if let indexPath = self.tableView.indexPathForSelectedRow {
                let album = AlbumsCollectionManager.shared.latestAlbums[indexPath.row]
                photosTableVC.albumDocId = album.documentId
            }
        }
    }
}
