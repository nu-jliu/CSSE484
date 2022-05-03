//
//  CoursesCollectionManager.swift
//  Rose Grade Tracker
//
//  Created by Jingkun Liu on 5/1/22.
//

import Foundation
import Firebase

class CoursesCollectionManager {
    
    static let shared = CoursesCollectionManager()
    var _collectionRef: CollectionReference
    
    private init() {
        self._collectionRef = Firestore.firestore().collection(Constants.FIRESTORE_COURSE_COLLETION_PATH)
    }
    
    var latestCourses = [[Course]]()
    var latestQuarters = [String]()
    
    func startListening(for studentId: String, changeListener: @escaping (() -> Void)) -> ListenerRegistration {
        // TODO: receive a changeListener
        
        let query = self._collectionRef
            .whereField(Constants.FIRESTORE_COURSE_TAKEN_BY_KEY, isEqualTo: studentId)
        //            .order(by: Constants.FIRESTORE_COURSE_YEAR_KEY, descending: true)
        //            .limit(to: 50)
        //            .order(by: Constants.FIRESTORE_COURSE_QUARTER_KEY, descending: true)
        //            .limit(to: 50)
        
        return query.addSnapshotListener { snapshot, err in
            guard let courseDocuments = snapshot?.documents else {
                print("ERROR: failed to fetching documents: \(err!)")
                return
            }
            
            self.latestCourses = [[Course]]()
            self.latestQuarters = [String]()
            for courseDoc in courseDocuments {
                let course = Course(snapshot: courseDoc)
                let quarter = "\(course.quarter) \(course.year - 1)-\(course.year)"
                
                var index = self.latestQuarters.firstIndex(of: quarter) ?? -1
                if index == -1 {
                    index = self.latestQuarters.count
                    self.latestQuarters.append(quarter)
                    self.latestCourses.append([Course]())
                }
                
                CoursesCollectionManager.shared.latestCourses[index].append(course)
            }
            
            changeListener()
        }
    }
    
    func stopListening(_ listenerRegisteration: ListenerRegistration?) {
        print("Removing the collection listener ...")
        listenerRegisteration?.remove()
    }
    
    //    func add(_ course: Course) {
    //        var ref: DocumentReference? = nil
    //        ref = self._collectionRef.addDocument(data: [
    //            MOVIE_QUOTE_QUOTE: mq.quote,
    //            MOVIE_QUOTE_MOVIE: mq.movie,
    //            MOVIE_QUOTE_LAST_TOUCHED: Timestamp.init(),
    //            MOVIE_QUOTE_AUTHER_UID: AuthManager.shared.currentUser!.uid
    //        ]) { err in
    //            if let e = err {
    //                print("ERROR: failed to add document \(e)")
    //            } else {
    //                print("Document added: \(ref!.documentID)")
    //            }
    //        }
    //    }
    
    func delete(_ documentId: String) {
        self._collectionRef.document(documentId).delete() { err in
            if let err = err {
                print("ERROR: failed to detele document \(err)")
            } else {
                print("Delete document \(documentId) sucessful")
            }
        }
    }
}
