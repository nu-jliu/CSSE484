//
//  AlbumMembersTableViewController.swift
//  Photo Buckets
//
//  Created by Jingkun Liu on 5/12/22.
//

import UIKit
import Firebase

class MemberTableViewCell: UITableViewCell {
    @IBOutlet weak var memberNameLabel: UILabel!
    @IBOutlet weak var memberEmailLabel: UILabel!
}

class AlbumMembersTableViewController: UITableViewController {
    
    var albumDocumentId: String?
    var albumDocListenerRegisteration: ListenerRegistration?
    var usersListenerRegisteration: ListenerRegistration?

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
        
        self.usersListenerRegisteration = UsersCollectionManager.shared.startsListening {
            self.tableView.reloadData()
        }
        
        if let docId = self.albumDocumentId {
            self.albumDocListenerRegisteration = AlbumDocumentManager.shared.startListening(for: docId) {
                self.tableView.reloadData()
            }
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        AlbumDocumentManager.shared.stopListening(self.albumDocListenerRegisteration)
        UsersCollectionManager.shared.stopListeneing(self.usersListenerRegisteration)
    }
    
    // MARK: = Button Actions
    
    @objc func showAddDialog() {
        let alertController = UIAlertController(title: "Add a Member", message: "Enter the email of Member", preferredStyle: .alert)
        
        alertController.addTextField { textfield in
            textfield.placeholder = "Member Email"
        }
        
        alertController.addAction(UIAlertAction(
            title: "Add Member",
            style: .default
        ) { action in
            let email = alertController.textFields?[0].text ?? ""
            AlbumDocumentManager.shared.addMember(email: email)
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
        return AlbumDocumentManager.shared.latestAlbum?.memberUids.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: Constants.MEMBER_CELL_IDENTIFIER,
            for: indexPath
        ) as! MemberTableViewCell

        // Configure the cell...
        if let uid = AlbumDocumentManager.shared.latestAlbum?.memberUids[indexPath.row] {
            let memberInfo = UsersCollectionManager.shared.userInfos[uid]
            cell.memberNameLabel.text = memberInfo?.name
            cell.memberEmailLabel.text = memberInfo?.email
        }
        
        return cell
    }
    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return AlbumDocumentManager.shared.latestAlbum?.memberUids[indexPath.row] != AlbumDocumentManager.shared.latestAlbum?.ownerUid
    }
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            if let uid = AlbumDocumentManager.shared.latestAlbum?.memberUids[indexPath.row] {
                AlbumDocumentManager.shared.removeMember(uid: uid)
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        return nil
    }
}
