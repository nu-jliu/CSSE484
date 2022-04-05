//
//  PhotoBucketsTableViewController.swift
//  Photo Buckets
//
//  Created by Jingkun Liu on 4/1/22.
//

import UIKit

class PhotoBucketsTableViewController: UITableViewController {

    var photos = [Photo]()
    
    let PHOTO_BUCKET_CELL_IDENTIFIER = "PhotoBucketCell"
    let PHOTO_BUCKET_DETAIL_SEGUE = "PhotoBucketDetailSegue"

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        self.navigationItem.leftBarButtonItem = self.editButtonItem
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(showAddAlertDialog))
        
        
//        let photo1 = Photo(title: "Buggatti", imageUrl: "https://hips.hearstapps.com/hmg-prod/images/14bugatti-divo-99leadgallery-1535035005.jpg?crop=0.941xw:0.864xh;0.0417xw,0.136xh&resize=1200:*")
//        let photo2 = Photo(title: "NASA", imageUrl: "https://www.washingtonpost.com/wp-apps/imrs.php?src=https://arc-anglerfish-washpost-prod-washpost.s3.amazonaws.com/public/4GGKKCRF64I6XHCKBXDCILCICQ.jpg&w=916")
//        self.photos.append(photo1)
//        self.photos.append(photo2)
    }
    
    @objc func showAddAlertDialog() {
        print("You pressed the add")
        
        let alertController = UIAlertController(title: "Add a Photo", message: "", preferredStyle: .alert)
        
        // add title text field
        alertController.addTextField { textField in
            textField.placeholder = "Title"
        }
        
        // add url text field
        alertController.addTextField { textField in
            textField.placeholder = "Photo URL"
        }
        
        // Cancel action
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel) { action in
            print("You pressed cancel")
        })
        
        // Add action
        alertController.addAction(UIAlertAction(title: "Add Photo", style: .default) { action in
            
            let titleTextField = alertController.textFields![0] as UITextField
            let urlTextField = alertController.textFields![1] as UITextField
            
            print("Title: \(titleTextField.text!), URL: \(urlTextField.text!)")
            
            let photo = Photo(title: titleTextField.text!, imageUrl: urlTextField.text!)
//            self.photos.insert(photo, at: 0)
//            self.tableView.reloadData()
            
            PhotoBucketsCollectionManager.shared.add(photo)
            
        })
        
        self.present(alertController, animated: true)
    }

    // MARK: - Table lifecycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        PhotoBucketsCollectionManager.shared.startsListening {
            print("Photos were updated")
            
            for photo in PhotoBucketsCollectionManager.shared.latestPhotos {
                print("Title: \(photo.title), ImageUrl: \(photo.imageUrl)")
            }
            
            self.tableView.reloadData()
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
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
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        // do nothing
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == self.PHOTO_BUCKET_DETAIL_SEGUE {
            let photoBucketDetailVC = segue.destination as! PhotoBucketDetailViewController
            if let indexPath = self.tableView.indexPathForSelectedRow {
//                photoBucketDetailVC.photo = self.photos[indexPath.row]
//                photoBucketDetailVC.photo = PhotoBucketsCollectionManager.shared.latestPhotos[indexPath.row]
                photoBucketDetailVC.setDocumentReference(docId: PhotoBucketsCollectionManager.shared.latestPhotos[indexPath.row].documentId!)
            }
        }
    }
    

}
