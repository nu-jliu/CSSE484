//
//  MembersSideMenuViewController.swift
//  Photo Buckets
//
//  Created by Jingkun Liu on 5/12/22.
//

import UIKit

class MembersSideMenuViewController: UIViewController {
    
    @IBOutlet weak var editAlbumNameButton: UIButton!
    @IBOutlet weak var leaveAlbumButton: UIButton!
    
    var membersTableViewCpontroller: AlbumMembersTableViewController {
        let navController = self.presentingViewController as! UINavigationController
        return navController.viewControllers.last as! AlbumMembersTableViewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        if let uid = AuthStateManager.shared.currentUser?.uid {
            if let ownerUid = AlbumDocumentManager.shared.latestAlbum?.ownerUid {
                self.editAlbumNameButton.isHidden = ownerUid != uid
                self.leaveAlbumButton.isHidden = ownerUid == uid
            }
        }
    }
    
    @IBAction func editAlbumNamePressed(_ sender: Any) {
        self.dismiss(animated: true)
        
        let alertController = UIAlertController(title: "Edit Album Name", message: "Enter a new album name", preferredStyle: .alert)
        
        alertController.addTextField { textfield in
            textfield.placeholder = "Album Name"
            textfield.text = AlbumDocumentManager.shared.latestAlbum?.name
        }
        
        alertController.addAction(UIAlertAction(
            title: "Submit",
            style: .default
        ) { action in
            let name = alertController.textFields?[0].text ?? ""
            AlbumDocumentManager.shared.update(name: name)
        })
        
        alertController.addAction(UIAlertAction(
            title: "Cancel",
            style: .cancel
        ))
        
        self.membersTableViewCpontroller.present(
            alertController,
            animated: true
        )
    }
    
    @IBAction func removeMembersPressed(_ sender: Any) {
        self.dismiss(animated: true)
        self.membersTableViewCpontroller.isEditing = !self.membersTableViewCpontroller.isEditing
    }
    
    @IBAction func leaveGroupPressed(_ sender: Any) {
        self.dismiss(animated: true)
        
        let tableVC = self.membersTableViewCpontroller
        
        let alertController = UIAlertController(title: "Leave Album?", message: "Would you like to leave the album", preferredStyle: .alert)
        
        alertController.addAction(UIAlertAction(
            title: "Confirm",
            style: .default
        ) { action in
            tableVC
                .navigationController?
                .popViewController(animated: true)
            
            if let uid = AuthStateManager.shared.currentUser?.uid {
                AlbumDocumentManager.shared.removeMember(uid: uid)
            }
        })
        
        alertController.addAction(UIAlertAction(
            title: "Cancel",
            style: .cancel
        ))
        
        self.membersTableViewCpontroller.present(
            alertController,
            animated: true
        )
    }
    
    @IBAction func backToAlbumsPressed(_ sender: Any) {
        self.dismiss(animated: true)
        self.membersTableViewCpontroller
            .navigationController?
            .popViewController(animated: true)
    }    
}
