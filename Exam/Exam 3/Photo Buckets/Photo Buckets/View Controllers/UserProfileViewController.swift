//
//  UserProfileViewController.swift
//  Photo Buckets
//
//  Created by Jingkun Liu on 4/28/22.
//

import UIKit
import Firebase

class UserProfileViewController: UIViewController {

    @IBOutlet weak var displayNameTextField: UITextField!
    @IBOutlet weak var profilePhotoImageView: UIImageView!
    
    var userListenerRegisteration: ListenerRegistration?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.profilePhotoImageView.layer.cornerRadius = self.profilePhotoImageView.frame.width / 2
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.userListenerRegisteration = UserDocumentManager.shared.startListening(
            for: AuthStateManager.shared.currentUser!.uid
        ) {
            self.updateView()
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    @IBAction func displayNameTextBoxChanged(_ sender: Any) {
        let authorName = self.displayNameTextField.text!
        UserDocumentManager.shared.updateName(name: authorName)
    }
    
    @IBAction func changeProfilePhotoPressed(_ sender: Any) {
        let imagePicker = UIImagePickerController()
        
        imagePicker.delegate = self
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            imagePicker.sourceType = .camera
        } else {
            imagePicker.sourceType = .photoLibrary
        }
        
        self.present(imagePicker, animated: true)
    }
    
    func updateView() {
        self.displayNameTextField.text = UserDocumentManager.shared.name
        
        if !UserDocumentManager.shared.photoUrl.isEmpty {
            PhotoUtils.load(
                imageView: self.profilePhotoImageView,
                from: UserDocumentManager.shared.photoUrl
            )
        }
    }
}

extension UserProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as! UIImage? {
            let sqImage = PhotoUtils.cropImageToSquare(image: image)
//            self.profilePhotoImageView.image = sqImage
            StorageManager.share.uploadProfilePhoto(uid: AuthStateManager.shared.currentUser!.uid, image: sqImage!)
        }
        
        picker.dismiss(animated: true)
    }
}
