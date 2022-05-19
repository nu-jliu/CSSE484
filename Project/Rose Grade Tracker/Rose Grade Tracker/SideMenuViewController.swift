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
    
    var coursesViewController: CourseListViewController {
        let navController = self.presentingViewController as! UINavigationController
        return navController.viewControllers.last as! CourseListViewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.profileImageView.layer.cornerRadius = self.profileImageView.frame.width / 2
        self.profileImageView.image = UIImage(named: "avatar-placeholder.png")
        //        self.courseSelectorMenu.awakeFromNib()
        self.showButtonMenu()
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
        self.dismiss(animated: true)
        
        let imagePicker = UIImagePickerController()
        
        imagePicker.delegate = self
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            imagePicker.sourceType = .camera
        } else {
            imagePicker.sourceType = .photoLibrary
        }
        
        self.coursesViewController.present(imagePicker, animated: true)
    }
    
    @IBAction func signOutPressed(_ sender: Any) {
        self.dismiss(animated: true) {
            AuthManager.shared.signOut()
        }
    }
    
    @IBAction func addCoursePressed(_ sender: Any) {
        print("Add Course")
    }
    
    func showButtonMenu() {
        let addAction = UIAction(
            title: "Add",
            image: nil,
            identifier: nil,
            discoverabilityTitle: nil,
            state: .on
        ) { action in
            print("Add")
            self.dismiss(animated: true)
            self.coursesViewController.performSegue(withIdentifier: Constants.ADD_COURSE_SEGUE, sender: self.coursesViewController)
        }
        
        let removeAction = UIAction(
            title: "Remove",
            image: nil,
            identifier: nil,
            discoverabilityTitle: nil,
            state: .on
        ) { action in
            print("Remove")
            self.dismiss(animated: true)
            self.coursesViewController.courseListTableView.isEditing = true
        }
        
        let doneEditAction = UIAction(
            title: "Done Editting",
            image: nil,
            identifier: nil,
            discoverabilityTitle: nil,
            state: .on
        ) { action in
            print("Edit")
            self.dismiss(animated: true)
            self.coursesViewController.courseListTableView.isEditing = false
        }
        
        let menu = UIMenu(
            title: "Menu",
            image: nil,
            identifier: nil,
            options: UIMenu.Options.singleSelection,
            children: [addAction, removeAction, doneEditAction]
        )
        
        self.addCourseButton.menu = menu
        self.addCourseButton.showsMenuAsPrimaryAction = true
    }
    
    @IBAction func editGradesPressed(_ sender: Any) {
        self.dismiss(animated: true)
        
        let alertController = UIAlertController(title: "Edit Grade", message: "Enter New Grades", preferredStyle: .alert)
        
        alertController.addTextField { textfield in
            textfield.placeholder = "GPA"
            
            if let gpa = UserDocumentManager.shared.GPA {
                textfield.text = "\(gpa)"
            }
        }
        
        alertController.addTextField { textfield in
            textfield.placeholder = "Credits"
            
            if let credits = UserDocumentManager.shared.credits {
                textfield.text = "\(credits)"
            }
        }
        
        alertController.addAction(UIAlertAction(
            title: "Cancel",
            style: .cancel
        ))
        
        alertController.addAction(UIAlertAction(
            title: "Submit",
            style: .default
        ) { action in
            if let gpa = Double(alertController.textFields?[0].text ?? "") {
                UserDocumentManager.shared.updateGPA(gpa)
            }
            
            if let credits = Int(alertController.textFields?[1].text ?? "") {
                UserDocumentManager.shared.updateCredits(credits)
            }
        })
        
        self.coursesViewController.present(alertController, animated: true)
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
