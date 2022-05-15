//
//  PhotoBucketDetailViewController.swift
//  Photo Buckets
//
//  Created by Jingkun Liu on 4/1/22.
//

import UIKit
import Firebase
import SwiftUI

class PhotoBucketDetailViewController: UIViewController {
    
    @IBOutlet weak var imageTitleLable: UILabel!
    @IBOutlet weak var photoBucketImageView: UIImageView!
    
    @IBOutlet weak var authorProfileImageView: UIImageView!
    @IBOutlet weak var authorNameLabel: UILabel!
    @IBOutlet weak var authorBoxStackView: UIStackView!
    
    var docId: String?
    var albumDocId: String?
    
    var userListenerRegisteration: ListenerRegistration?
    var photoListenerRegisteration: ListenerRegistration?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.authorProfileImageView.layer.cornerRadius = self.authorProfileImageView.frame.width / 2
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.photoListenerRegisteration = PhotoBucketDocumentManager.shared.startListening(for: self.docId!, onAlbum: self.albumDocId!) {
            print("Photo updated")
            
            if AuthStateManager.shared.currentUser?.uid ==  PhotoBucketDocumentManager.shared.latestPhoto?.authorId {
                self.navigationItem.rightBarButtonItem = UIBarButtonItem(
                    barButtonSystemItem: .edit,
                    target: self,
                    action: #selector(self.showPhotoEditDialog)
                )
            }
            
            self.updateView()
            
            if let authorUID = PhotoBucketDocumentManager.shared.latestPhoto?.authorId {
                UserDocumentManager.shared.stopListening(self.userListenerRegisteration)
                self.userListenerRegisteration = UserDocumentManager.shared.startListening(for: authorUID) {
                    self.updateAuthorBox()
                }
            }
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        PhotoBucketDocumentManager.shared.stopListening(self.photoListenerRegisteration)
    }
    
    @objc func showPhotoEditDialog() {
        print("You pressed the edit button")
        
        let alertController = UIAlertController(
            title: "Edit a Photo",
            message: "",
            preferredStyle: .alert
        )
        
        // add title text field
        alertController.addTextField { textField in
            textField.placeholder = "Caption"
            textField.text = PhotoBucketDocumentManager.shared.latestPhoto?.title
        }
        
        // add cancel action
        alertController.addAction(UIAlertAction(
            title: "Cancel",
            style: .cancel
        ))
        
        // add edit caption action
        alertController.addAction(UIAlertAction(
            title: "Edit Caption",
            style: .default
        ) { action in
            let titleTextField = alertController.textFields![0] as UITextField
            PhotoBucketDocumentManager.shared.update(title: titleTextField.text!)
        })
        
        // add edit photo action
        alertController.addAction(UIAlertAction(title: "Re-upload Photo", style: .default) { action in
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                imagePicker.sourceType = .camera
            } else {
                imagePicker.sourceType = .photoLibrary
            }
            
            self.present(imagePicker, animated: true)
        })
        
        self.present(alertController, animated: true)
    }
    
    func updateView() {
        if let photo = PhotoBucketDocumentManager.shared.latestPhoto {
            print("Title = \(photo.title)")
            self.imageTitleLable.text = photo.title
        
            
            PhotoUtils.load(
                imageView: self.photoBucketImageView,
                from: photo.imageUrl
            )
        }
    }
    
    func updateAuthorBox() {
        self.authorBoxStackView.isHidden = UserDocumentManager.shared.name.isEmpty
        
        let authorName = UserDocumentManager.shared.name
        let profilePhotoUrl = UserDocumentManager.shared.photoUrl
        
        if !authorName.isEmpty {
            self.authorNameLabel.text = authorName
        }
        
        if !profilePhotoUrl.isEmpty {
            PhotoUtils.load(imageView: self.authorProfileImageView, from: profilePhotoUrl)
        }
    }
}

extension PhotoBucketDetailViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as! UIImage? {
            StorageManager.share.uploadPhoto(photoDoc: nil, image: image)
        }
        
        picker.dismiss(animated: true)
    }
}
