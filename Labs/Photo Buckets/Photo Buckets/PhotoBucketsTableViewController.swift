//
//  PhotoBucketsTableViewController.swift
//  Photo Buckets
//
//  Created by Jingkun Liu on 4/1/22.
//

import UIKit
import Firebase

class PhotoBucketsTableViewController: UITableViewController {

    var photos = [Photo]()
    var photoRef: DocumentReference?
    
    let PHOTO_BUCKET_CELL_IDENTIFIER = "PhotoBucketCell"
    let PHOTO_BUCKET_DETAIL_SEGUE = "PhotoBucketDetailSegue"
    
    var showOnlyMyPhoto = false
    var logoutHandle: AuthStateDidChangeListenerHandle?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
//        self.navigationItem.leftBarButtonItem = self.editButtonItem
//        self.navigationItem.leftBarButtonItem = UIBarButtonItem(
//            title: nil,
//            style: .plain,
//            target: self,
//            action: nil
//        )
        
//        self.navigationItem.rightBarButtonItem = UIBarButtonItem(
//            title: "Menu",
//            style: .plain,
//            target: self,
//            action: #selector(showMenu)
//        )

        self.navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(self.showAddAlertDialog)
        )
        
//        let photo1 = Photo(title: "Buggatti", imageUrl: "https://hips.hearstapps.com/hmg-prod/images/14bugatti-divo-99leadgallery-1535035005.jpg?crop=0.941xw:0.864xh;0.0417xw,0.136xh&resize=1200:*")
//        let photo2 = Photo(title: "NASA", imageUrl: "https://www.washingtonpost.com/wp-apps/imrs.php?src=https://arc-anglerfish-washpost-prod-washpost.s3.amazonaws.com/public/4GGKKCRF64I6XHCKBXDCILCICQ.jpg&w=916")
//        self.photos.append(photo1)
//        self.photos.append(photo2)
    }
    
    @objc func showMenu() {
        print("You pressed menu")
        
        let alertController = UIAlertController(
            title: "Photo Bucket Options",
            message: nil,
            preferredStyle: .actionSheet
        )
        
        // add photo action
        alertController.addAction(
            UIAlertAction(
                title: "Add a Photo",
                style: .default
            ) { action in
                print(" You pressed add photo")
                
//                self.navigationItem.rightBarButtonItem = UIBarButtonItem(
//                    barButtonSystemItem: .add,
//                    target: self,
//                    action: #selector(self.showAddAlertDialog)
//                )
                
                self.showAddAlertDialog()
            })
        
        // edit action
        alertController.addAction(
            UIAlertAction(
                title: self.isEditing ? "Done Editting" : "Select photos to edit",
                style: .default
            ) { action in
                print("You pressed edit")
                self.isEditing = !self.isEditing
            })
        
        // show only my photos action
        alertController.addAction(
            UIAlertAction(
                title: self.showOnlyMyPhoto ? "Show All Photo" : "Show Only My Photo",
                style: .default
            ) { action in
                print("You presses show my photo")
                
                self.showOnlyMyPhoto = !self.showOnlyMyPhoto
                PhotoBucketsCollectionManager.shared.startsListening(self.showOnlyMyPhoto) {
                    self.tableView.reloadData()
                }
            })
        
        // sign out action
        alertController.addAction(
            UIAlertAction(
                title: "Sign Out",
                style: .destructive
            ) { action in
                AuthStateManager.shared.signOut {
                    print("ERROR: signout failed")
                }
            })
        
        // add cancel action
        alertController.addAction(
            UIAlertAction(
                title: "Cancel",
                style: .cancel))
        
        self.present(alertController, animated: true)
    }
    
    @objc func showAddAlertDialog() {
        print("You pressed the add")
        
        let alertController = UIAlertController(title: "Add a Photo", message: "", preferredStyle: .alert)
        
        // add title text field
        alertController.addTextField { textField in
            textField.placeholder = "Title"
        }
        
//        // add url text field
//        alertController.addTextField { textField in
//            textField.placeholder = "Photo URL"
//        }
        
        // Cancel action
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel) { action in
            print("You pressed cancel")
        })
        
        // Add action
        alertController.addAction(UIAlertAction(title: "Upload Photo", style: .default) { action in
            
            self.stopListeningForPhotos()
            
            let titleTextField = alertController.textFields![0] as UITextField
            
            let photo = Photo(title: titleTextField.text!, imageUrl: "")
            
            self.photoRef = PhotoBucketsCollectionManager.shared.add(photo)
            
            let imagePicker = UIImagePickerController()
            
            imagePicker.delegate = self
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                imagePicker.sourceType = .camera
            } else {
                imagePicker.sourceType = .photoLibrary
            }
            
            self.present(imagePicker, animated: true)
//            let urlTextField = alertController.textFields![1] as UITextField
            
//            print("Title: \(titleTextField.text!), URL: \(urlTextField.text!), UID: \(AuthStateManager.shared.currentUser?.uid ?? "")")
            
            
            
//            PhotoBucketsCollectionManager.shared.add(photo)
            
        })
        
        self.present(alertController, animated: true)
    }

    // MARK: - Table lifecycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.startListeningForPhotots()
        
        self.logoutHandle = AuthStateManager.shared.addLogoutObserver {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        AuthStateManager.shared.removeObserver(authStateHandle: self.logoutHandle)
    }
    
    func startListeningForPhotots() {
        PhotoBucketsCollectionManager.shared.startsListening(self.showOnlyMyPhoto) {
            print("Photos were updated")
            
//            for photo in PhotoBucketsCollectionManager.shared.latestPhotos {
//                print("Title: \(photo.title), ImageUrl: \(photo.imageUrl)")
//            }
            
            self.tableView.reloadData()
        }
    }
    
    func stopListeningForPhotos() {
        PhotoBucketsCollectionManager.shared.stopListening()
    }
    
    // MARK: - Table view data source
    


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return PhotoBucketsCollectionManager.shared.latestPhotos.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: PHOTO_BUCKET_CELL_IDENTIFIER, for: indexPath)

        // Configure the cell...

        cell.textLabel?.text = PhotoBucketsCollectionManager.shared.latestPhotos[indexPath.row].title
        cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        // do nothing
        if editingStyle == .delete {
            let photo = PhotoBucketsCollectionManager.shared.latestPhotos[indexPath.row]
            PhotoBucketsCollectionManager.shared.delete(photo.documentId ?? "")
            StorageManager.share.deletePhoto(photo.documentId ?? "")
        }
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        let photo = PhotoBucketsCollectionManager.shared.latestPhotos[indexPath.row]
        return photo.authorId == AuthStateManager.shared.currentUser?.uid
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == self.PHOTO_BUCKET_DETAIL_SEGUE {
            let photoBucketDetailVC = segue.destination as! PhotoBucketDetailViewController
            if let indexPath = self.tableView.indexPathForSelectedRow {
                photoBucketDetailVC.docId = PhotoBucketsCollectionManager.shared.latestPhotos[indexPath.row].documentId
                print("Selected row \(indexPath.row)")
                print("doc id = \(PhotoBucketsCollectionManager.shared.latestPhotos[indexPath.row].documentId ?? "-1")")
            }
        }
    }
}

extension PhotoBucketsTableViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
        self.startListeningForPhotots()
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as! UIImage? {
            StorageManager.share.uploadPhoto(photoDoc: self.photoRef, image: image)
        }
        
        picker.dismiss(animated: true)
        self.startListeningForPhotots()
    }
}
