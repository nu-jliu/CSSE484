//
//  Course.swift
//  Rose Grade Tracker
//
//  Created by Jingkun Liu on 4/30/22.
//

import Foundation
import Firebase

class Course {
    var name: String
    var section: String
    var quarter: String
    var year: Int
    var documentId: String?
    
    // weights
    var assignmentsWeight: Int?
    var examsWeight: Int?
    var labsWeight: Int?
    var quizzesWeight: Int?
    var partWeight: Int?
    
    // grades
    var partGrade: Double?
    var assignmentsGrade = [(weight: Int, grade: Double, displayName: String)]()
    var examsGrade = [(weight: Int, grade: Double, displayName: String)]()
    var labsGrade = [(weight: Int, grade: Double, displayName: String)]()
    var quizzesGrade = [(weight: Int, grade: Double, displayName: String)]()
    
    init(snapshot: DocumentSnapshot) {
        self.documentId = snapshot.documentID
        self.name = "\(snapshot.get(Constants.FIRESTORE_COURSE_NUMBER_KEY) ?? "") \(snapshot.get(Constants.FIRESTORE_COURSE_NAME_KEY) ?? "")"
        self.section = String(format: "%02d", snapshot.get(Constants.FIRESTORE_COURSE_SECTION_KEY) as! Int)
        self.quarter = Utils.parseQuarter(quarter: snapshot.get(Constants.FIRESTORE_COURSE_QUARTER_KEY) as! Int)
        self.year = snapshot.get(Constants.FIRESTORE_COURSE_YEAR_KEY) as! Int
        
        self.partWeight = snapshot.get(Constants.FIRESTORE_COURSE_PARTICIPATION_WEIGHT_KEY) as? Int
        self.partGrade = snapshot.get(Constants.FIRESTORE_COURSE_PARTICIPATION_GRADE_KEY) as? Double
        
        // assignments
        self.assignmentsWeight = snapshot.get(Constants.FIRESTORE_COURSE_ASSIGNMENTS_WEIGHT_KEY) as? Int
        if let assignmentGrades = snapshot.get(Constants.FIRESTORE_COURSE_ASSIGNMENTS_GRADE_KEY)
            as? [[String: Any]] {
            
            for gradeDict in assignmentGrades {
                let weight = gradeDict[Constants.FIRESTORE_WEIGHT_KEY] as! Int
                let grade = gradeDict[Constants.FIRESTORE_GRADE_KEY] as! Double
                let displayName = gradeDict[Constants.FIREBASE_NAME_KEY] as! String
                self.assignmentsGrade.append((weight, grade, displayName))
                print("assignment 1")
            }
        }
        
        // exams
        self.examsWeight = snapshot.get(Constants.FIRESTORE_COURSE_EXAMS_WEIGHT_KEY) as? Int
        if let examGrades = snapshot.get(Constants.FIRESTORE_COURSE_EXAMS_GRADE_KEY)
            as? [[String: Any]] {
            
            for gradeDict in examGrades {
                let weight = gradeDict[Constants.FIRESTORE_WEIGHT_KEY] as! Int
                let grade = gradeDict[Constants.FIRESTORE_GRADE_KEY] as! Double
                let displayName = gradeDict[Constants.FIREBASE_NAME_KEY] as! String
                self.examsGrade.append((weight, grade, displayName))
            }
        }
        
        // labs
        self.labsWeight = snapshot.get(Constants.FIRESTORE_COURSE_LABS_WEIGHT_KEY) as? Int
        if let labGrades = snapshot.get(Constants.FIRESTORE_COURSE_LABS_GRADE_KEY)
            as? [[String: Any]] {
            
            for gradeDict in labGrades {
                let weight = gradeDict[Constants.FIRESTORE_WEIGHT_KEY] as! Int
                let grade = gradeDict[Constants.FIRESTORE_GRADE_KEY] as! Double
                let displayName = gradeDict[Constants.FIREBASE_NAME_KEY] as! String
                self.labsGrade.append((weight, grade, displayName))
                print("lab 1")
            }
        }
        
        // quizzes
        self.quizzesWeight = snapshot.get(Constants.FIRESTORE_COURSE_QUIZZES_WEIGHT_KEY) as? Int
        if let quizGrades = snapshot.get(Constants.FIRESTORE_COURSE_QUIZZES_GRADE_KEY)
            as? [[String: Any]] {
            
            for gradeDict in quizGrades {
                let weight = gradeDict[Constants.FIRESTORE_WEIGHT_KEY] as! Int
                let grade = gradeDict[Constants.FIRESTORE_GRADE_KEY] as! Double
                let displayName = gradeDict[Constants.FIREBASE_NAME_KEY] as! String
                self.quizzesGrade.append((weight, grade, displayName))
            }
        }
    }
}
