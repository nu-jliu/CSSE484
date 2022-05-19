//
//  CourseDocumentManager.swift
//  Rose Grade Tracker
//
//  Created by Jingkun Liu on 5/2/22.
//

import Foundation
import Firebase

class CourseDocumentManager {
    
    var latestCourse: Course?
    
    static let shared = CourseDocumentManager()
    var _collectionRef: CollectionReference
    
    private init() {
        self._collectionRef = Firestore.firestore().collection(Constants.FIRESTORE_COURSE_COLLETION_PATH)
    }
    
    func startListening(for documentId: String, changeListener: @escaping (() -> Void)) -> ListenerRegistration {
        return self._collectionRef.document(documentId).addSnapshotListener { docSnapshot, err in
            guard let document = docSnapshot else {
                print("ERROR: failed to fetch the data \(err!)")
                return
            }
            
            guard document.data() != nil else {
                print("Document \(document.documentID) is empty")
                return
            }
            
            self.latestCourse = Course.init(snapshot: document)
            changeListener()
        }
    }
    
    func stopListening(_ listenerRegisteration: ListenerRegistration?) {
        print("Removing the document listener ...")
        listenerRegisteration?.remove()
    }
    
    func updateParticipation(grade: Double, weight: Int) {
        self._collectionRef.document(self.latestCourse!.documentId!).updateData([
            Constants.FIRESTORE_COURSE_PARTICIPATION_WEIGHT_KEY: weight,
            Constants.FIRESTORE_COURSE_PARTICIPATION_GRADE_KEY: grade
        ]) { err in
            if let err = err {
                print("Failed to update document \(err)")
            } else {
                print("Document \(self.latestCourse?.documentId ?? "") updated successfully")
            }
        }
    }
    
    func updateGrade(type: GradeType, grades: [(weight: Int, grade: Double, displayName: String)]) {
        var gradeMap = [[String: Any]]()
        
        for grade in grades {
            var gradeDict = [String: Any]()
            
            gradeDict[Constants.FIRESTORE_WEIGHT_KEY] = grade.weight
            gradeDict[Constants.FIRESTORE_NAME_KEY] = grade.displayName
            gradeDict[Constants.FIRESTORE_GRADE_KEY] = grade.grade
            
            gradeMap.append(gradeDict)
        }
        
        if let docId = self.latestCourse?.documentId {
            let docRef = self._collectionRef.document(docId)
        
            switch type {
            case .participation:
                print("invalid operation")
                
            case .assignments:
                docRef.updateData([
                    Constants.FIRESTORE_COURSE_ASSIGNMENTS_GRADE_KEY: gradeMap
                ])
                
            case .exams:
                docRef.updateData([
                    Constants.FIRESTORE_COURSE_EXAMS_GRADE_KEY: gradeMap
                ])
                
            case .labs:
                docRef.updateData([
                    Constants.FIRESTORE_COURSE_LABS_GRADE_KEY: gradeMap
                ])
                
            case .quizzes:
                docRef.updateData([
                    Constants.FIRESTORE_COURSE_QUIZZES_GRADE_KEY: gradeMap
                ])
            }
        }
    }
    
    func removeGrade(type: GradeType) {
        if let docId = self.latestCourse?.documentId {

            let docRef = self._collectionRef.document(docId)
            switch type {
            case .participation:
                docRef.updateData([
                    Constants.FIRESTORE_COURSE_PARTICIPATION_WEIGHT_KEY: FieldValue.delete(),
                    Constants.FIRESTORE_COURSE_PARTICIPATION_GRADE_KEY: FieldValue.delete()
                ])
            case .assignments:
                docRef.updateData([
                    Constants.FIRESTORE_COURSE_ASSIGNMENTS_WEIGHT_KEY: FieldValue.delete(),
                    Constants.FIRESTORE_COURSE_ASSIGNMENTS_GRADE_KEY: FieldValue.delete()
                ])
            case .exams:
                docRef.updateData([
                    Constants.FIRESTORE_COURSE_EXAMS_WEIGHT_KEY: FieldValue.delete(),
                    Constants.FIRESTORE_COURSE_EXAMS_GRADE_KEY: FieldValue.delete()
                ])
            case .labs:
                docRef.updateData([
                    Constants.FIRESTORE_COURSE_LABS_WEIGHT_KEY: FieldValue.delete(),
                    Constants.FIRESTORE_COURSE_LABS_GRADE_KEY: FieldValue.delete()
                ])
            case .quizzes:
                docRef.updateData([
                    Constants.FIRESTORE_COURSE_QUIZZES_WEIGHT_KEY: FieldValue.delete(),
                    Constants.FIRESTORE_COURSE_QUIZZES_GRADE_KEY: FieldValue.delete()
                ])
            }
        }
    }
    
    func updateWeight(type: GradeType, weight: Int?) {
        if let weight = weight {
            if let docId = self.latestCourse?.documentId {
                let docRef = self._collectionRef.document(docId)
                
                switch type {
                case .participation:
                    docRef.updateData([
                        Constants.FIRESTORE_COURSE_PARTICIPATION_WEIGHT_KEY: weight
                    ])
                case .assignments:
                    docRef.updateData([
                        Constants.FIRESTORE_COURSE_ASSIGNMENTS_WEIGHT_KEY: weight
                    ])
                case .labs:
                    docRef.updateData([
                        Constants.FIRESTORE_COURSE_LABS_WEIGHT_KEY: weight
                    ])
                case .exams:
                    docRef.updateData([
                        Constants.FIRESTORE_COURSE_EXAMS_WEIGHT_KEY: weight
                    ])
                case .quizzes:
                    docRef.updateData([
                        Constants.FIRESTORE_COURSE_QUIZZES_WEIGHT_KEY: weight
                    ])
                }
            }
            
        }
    }
}
