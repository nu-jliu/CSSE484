//
//  SideMenuViewController.swift
//  Rose Grade Tracker
//
//  Created by Jingkun Liu on 5/3/22.
//

import UIKit
import SwiftUI
import Firebase

class SideMenuViewController: UIViewController {
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var addCourseButton: UIButton!
    
    var userDocumentListenerRegisteration: ListenerRegistration?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.profileImageView.layer.cornerRadius = self.profileImageView.frame.width / 2
        self.profileImageView.image = UIImage(named: "avatar-placeholder.png")
        //        self.courseSelectorMenu.awakeFromNib()
        
        let addAction = UIAction(title: "Add", image: nil, identifier: nil, discoverabilityTitle: nil, state: .on) { action in
            print("Add")
        }
        
        let menu = UIMenu(title: "Menu", image: nil, identifier: nil, options: UIMenu.Options.singleSelection, children: [addAction])
        
        self.addCourseButton.menu = menu
        self.addCourseButton.showsMenuAsPrimaryAction = true
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.userDocumentListenerRegisteration = UserDocumentManager.shared.startListening(
            for: AuthManager.shared.currentUser!.uid
        ) {
            Utils.load(imageView: self.profileImageView, from: UserDocumentManager.shared.photoUrl)
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        UserDocumentManager.shared.stopListening(self.userDocumentListenerRegisteration)
    }
    
    @IBAction func changeAvatarPressed(_ sender: Any) {
        let imagePicker = UIImagePickerController()
        
        imagePicker.delegate = self
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            imagePicker.sourceType = .camera
        } else {
            imagePicker.sourceType = .photoLibrary
        }
        
        self.present(imagePicker, animated: true)
    }
    
    @IBAction func signOutPressed(_ sender: Any) {
        self.dismiss(animated: true) {
            AuthManager.shared.signOut()
        }
    }
    
    @IBAction func addCoursePressed(_ sender: Any) {
        print("Add Course")
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

extension SideMenuViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as! UIImage? {
            StorageManager.share.uploadProfilePhoto(
                uid: AuthManager.shared.currentUser!.uid,
                image: image
            )
        }
        
        picker.dismiss(animated: true)
    }
}
