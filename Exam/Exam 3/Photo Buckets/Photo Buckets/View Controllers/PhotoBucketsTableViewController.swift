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
    
    var photosListenerRegisteration: ListenerRegistration?
    
    var showOnlyMyPhoto = false
    var albumDocId: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        //        self.navigationItem.leftBarButtonItem = self.editButtonItem
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(self.showAddAlertDialog)
        )
    }
    
    // MARK: - Table lifecycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.startListeningForPhotots()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    func startListeningForPhotots() {
        self.photosListenerRegisteration = PhotoBucketsCollectionManager.shared.startsListening(self.showOnlyMyPhoto, for: self.albumDocId!) {
            print("Photos were updated")
            
            self.tableView.reloadData()
        }
    }
    
    func stopListeningForPhotos() {
        PhotoBucketsCollectionManager.shared.stopListening(self.photosListenerRegisteration)
    }
    
    // MARK: - Button actions
    
    @objc func showAddAlertDialog() {
        print("You pressed the add")
        
        let alertController = UIAlertController(title: "Add a Photo", message: "", preferredStyle: .alert)
        
        // add title text field
        alertController.addTextField { textField in
            textField.placeholder = "Title"
        }
        
        // Cancel action
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel) { action in
            print("You pressed cancel")
        })
        
        // Add action
        alertController.addAction(UIAlertAction(title: "Upload Photo", style: .default) { action in
            self.stopListeningForPhotos()
            
            let titleTextField = alertController.textFields![0] as UITextField
            
            let photo = Photo(
                title: titleTextField.text!,
                imageUrl: ""
            )
            
            self.photoRef = PhotoBucketsCollectionManager.shared.add(photo)
            
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
    
    // MARK: - Table view data source
    
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return PhotoBucketsCollectionManager.shared.latestPhotos.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.PHOTO_BUCKET_CELL_IDENTIFIER, for: indexPath)
        
        // Configure the cell...
        
        cell.textLabel?.text = PhotoBucketsCollectionManager.shared.latestPhotos[indexPath.row].title
        cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        // do nothing
        if editingStyle == .delete {
            if let docId = PhotoBucketsCollectionManager.shared.latestPhotos[indexPath.row].documentId {
                PhotoBucketsCollectionManager.shared.delete(docId)
                StorageManager.share.deletePhoto(docId)
            }
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
        
        if segue.identifier == Constants.PHOTO_BUCKET_DETAIL_SEGUE {
            let photoBucketDetailVC = segue.destination as! PhotoBucketDetailViewController
            if let indexPath = self.tableView.indexPathForSelectedRow {
                let photo = PhotoBucketsCollectionManager.shared.latestPhotos[indexPath.row]
                photoBucketDetailVC.docId = photo.documentId
                photoBucketDetailVC.albumDocId = self.albumDocId
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
