//
//  PhotoBucketDetailViewController.swift
//  Photo Buckets
//
//  Created by Jingkun Liu on 4/1/22.
//

import UIKit
import Firebase

class PhotoBucketDetailViewController: UIViewController {
    
    @IBOutlet weak var imageTitleLable: UILabel!
    @IBOutlet weak var photoBucketImageView: UIImageView!
    
    var photo: Photo!
    private var _documentReference: DocumentReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self._documentReference.addSnapshotListener { docSnapshot, err in
            guard let doc = docSnapshot else {
                print("ERROR: failed to fetch the document \(err!)")
                return
            }
            
            guard let data = doc.data() else {
                print("ERROR: document is empty")
                return
            }
            
            print("Current Document \(data)")
            self.photo = Photo(snaphot: doc)
            self.updateView()
        }
    }
    
    func updateView() {
        self.imageTitleLable.text = self.photo.title
        
        let imageStr = self.photo.imageUrl
        if let imageUrl = URL(string: imageStr) {
            DispatchQueue.global().async {
                do {
                    let data = try Data(contentsOf: imageUrl)
                    DispatchQueue.main.async {
                        self.photoBucketImageView.image = UIImage(data: data)
                    }
                } catch {
                    print("ERROR: downloading image failed: \(error)")
                }
            }
        }
    }
    
    func setDocumentReference(docId: String) {
        self._documentReference = Firestore.firestore().collection(Constants.FIREBASE_PHOTOS_COLLECTION_PATH).document(docId)
    }
}
