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
    
    var docId: String?
    var photoListenerRegisteration: ListenerRegistration?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(showPhotoEditDialog))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.photoListenerRegisteration = PhotoBucketDocumentManager.shared.startListening(for: self.docId!) {
            print("Photo updated")
            
            self.updateView()
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        PhotoBucketDocumentManager.shared.stopListening(self.photoListenerRegisteration)
    }
    
    @objc func showPhotoEditDialog() {
        print("You pressed the edit button")
        
        let alertController = UIAlertController(title: "Edit a Photo", message: "", preferredStyle: .alert)
        
        // add title text field
        alertController.addTextField { textField in
            textField.placeholder = "Title"
            textField.text = PhotoBucketDocumentManager.shared.latestPhoto?.title
        }
        
        // add image url field
        alertController.addTextField { textField in
            textField.placeholder = "Image URL"
            textField.text = PhotoBucketDocumentManager.shared.latestPhoto?.imageUrl
        }
        
        // add cancel action
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel) { action in
            print("You pressed the cancel")
        })
        
        // add edit action
        alertController.addAction(UIAlertAction(title: "Edit Photo", style: .default) { action in
            
            let titleTextField = alertController.textFields![0] as UITextField
            let urlTextField = alertController.textFields![1] as UITextField
            
            PhotoBucketDocumentManager.shared.update(title: titleTextField.text!, url: urlTextField.text!)
        })
        
        self.present(alertController, animated: true)
    }
    
    func updateView() {
        if let photo = PhotoBucketDocumentManager.shared.latestPhoto {
            print("Title = \(photo.title)")
            self.imageTitleLable.text = photo.title
        
            if let imageUrl = URL(string: photo.imageUrl) {
                DispatchQueue.global().async {
                    do {
                        let data = try Data(contentsOf: imageUrl)
                        DispatchQueue.main.async {
                            self.photoBucketImageView.image = UIImage(data: data)
                            print("Image updated")
                        }
                    } catch {
                        print("ERROR: downloading image failed: \(error)")
                    }
                }
            }
        }
    }
}
