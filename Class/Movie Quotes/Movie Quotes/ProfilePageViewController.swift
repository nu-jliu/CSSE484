//
//  ProfilePageViewController.swift
//  Movie Quotes
//
//  Created by Jingkun Liu on 4/25/22.
//

import UIKit
import Firebase

class ProfilePageViewController: UIViewController {

    @IBOutlet weak var displayNameTextField: UITextField!
    @IBOutlet weak var profilePhotoImageView: UIImageView!
    
    var userListenerRegisteration: ListenerRegistration?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.profilePhotoImageView.layer.cornerRadius = self.profilePhotoImageView.frame.width/2
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.userListenerRegisteration = UserDocumentManager.shared.startListening(for: AuthManager.shared.currentUser!.uid) {
            self.updateView()
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        UserDocumentManager.shared.stopListening(self.userListenerRegisteration)
    }
    
    @IBAction func displayNameDidChange(_ sender: Any) {
        print("TODO: change display name to \(self.displayNameTextField.text ?? "")")
        UserDocumentManager.shared.updateName(name: self.displayNameTextField.text!)
    }
    
    @IBAction func pressedChangeProfilePhoto(_ sender: Any) {
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
//        print("TODO: show the name: \(UserDocumentManager.shared.name)")
//        print("TODO: show the photoUrl: \(UserDocumentManager.shared.photoUrl)")
        
        self.displayNameTextField.text = UserDocumentManager.shared.name
        
        if !UserDocumentManager.shared.photoUrl.isEmpty {
            ImageUtils.load(imageView: self.profilePhotoImageView, from: UserDocumentManager.shared.photoUrl)
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


extension ProfilePageViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as! UIImage? {
//            self.profilePhotoImageView.image = image
            StorageManager.share.uploadProfilePhoto(
                uid: AuthManager.shared.currentUser!.uid,
                image: image)
        }
        
        picker.dismiss(animated: true)
    }
}
