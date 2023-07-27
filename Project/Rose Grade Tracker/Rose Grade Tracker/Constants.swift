//
//  Constants.swift
//  Rose Grade Tracker
//
//  Created by Jingkun Liu on 4/30/22.
//

import Foundation

class Constants {
    // courses
    static let FIRESTORE_COURSE_COLLETION_PATH = "courses"
    static let FIRESTORE_COURSE_NUMBER_KEY = "courseNumber"
    static let FIRESTORE_COURSE_NAME_KEY = "courseName"
    static let FIRESTORE_COURSE_SECTION_KEY = "section"
    static let FIRESTORE_COURSE_QUARTER_KEY = "quarter"
    static let FIRESTORE_COURSE_YEAR_KEY = "year"
    static let FIRESTORE_COURSE_TAKEN_BY_KEY = "takenBy"
    static let FIREBASE_COURSE_CREDIT_KEY = "credit"
    
    // Participation Grade
    static let FIRESTORE_COURSE_PARTICIPATION_GRADE_KEY = "participationGrade"
    static let FIRESTORE_COURSE_PARTICIPATION_WEIGHT_KEY = "participationWeight"
    
    // Assignments Grades
    static let FIRESTORE_COURSE_ASSIGNMENTS_GRADE_KEY = "assignmentsGrades"
    static let FIRESTORE_COURSE_ASSIGNMENTS_WEIGHT_KEY = "assignmentsWeight"
    
    // Exam Grades
    static let FIRESTORE_COURSE_EXAMS_GRADE_KEY = "examsGrades"
    static let FIRESTORE_COURSE_EXAMS_WEIGHT_KEY = "examsWeight"
    
    // Labs Grades
    static let FIRESTORE_COURSE_LABS_GRADE_KEY = "labsGrades"
    static let FIRESTORE_COURSE_LABS_WEIGHT_KEY = "labsWeight"
    
    // Quizzes Grades
    static let FIRESTORE_COURSE_QUIZZES_GRADE_KEY = "quizzesGrades"
    static let FIRESTORE_COURSE_QUIZZES_WEIGHT_KEY = "quizzesWeight"
    
    // Grade Keys
    static let FIRESTORE_WEIGHT_KEY = "weight"
    static let FIRESTORE_GRADE_KEY = "grade"
    static let FIRESTORE_NAME_KEY = "name"
    
    // users
    static let FIRESTORE_USER_COLLECTION_PATH = "users"
    static let FIRESTORE_USER_NAME = "name"
    static let FIRESTORE_USER_PHOTO_URL = "photoUrl"
    static let FIRESTORE_USER_CURRENT_GPA = "currentGPA"
    static let FIRESTORE_USER_CURRENT_CREDITS = "currentCredits"
    
    // Course Templates
    static let FIRESTORE_COURSE_TEMPLATES_COLLECTION_PATH = "templates"
    static let FIRESTORE_COURSE_TEMPLATES_NAME_KEY = "name"
    static let FIRESTORE_COURSE_TEMPLATES_NUMBER_KEY = "number"
    static let FIRESTORE_COURSE_TEMPLATES_PARTICIPATION_WEIGHT_KEY = "pWeight"
    static let FIRESTORE_COURSE_TEMPLATES_ASSIGNMENTS_WEIHGT_KEY = "aWeight"
    static let FIRESTORE_COURSE_TEMPLATES_EXAMS_WEIGHT_KEY = "eWeight"
    static let FIRESTORE_COURSE_TEMPLATES_LABS_WEIGHT_KEY = "lWeight"
    static let FIRESTORE_COURSE_TEMPLATES_QUIZZES_WEIGHT_KEY = "qWeight"
    
    // Translation
    static let FIRESTORE_COURSE_NAME_TRANSLATED_KEY = "translatedName"
    static let FIRESTORE_COURSE_NAME_GERMAN = "de"
    static let FIRESTORE_COURSE_NAME_ENGLISH = "en"
    static let FIRESTORE_COURSE_NAME_SPANISH = "es"
    static let FIRESTORE_COURSE_NAME_FRANCH = "fr"
    static let FIRESTORE_COURSE_NAME_CHINESE = "zh"
    
    // Cloud Functions
    static let CLOUD_FUNCTIONS_URL = "https://us-central-rose-gradebook-ios.cloudfunctions.net"
    
    // Rosefire
    static let ROSEFIRE_REGISTRY_TOKEN = "3e7cf079-71b1-4be1-93b5-213b46e17a2a"
    
    // Segue Identifier
    static let SHOW_COURSE_LIST_SEQUE = "showCourseListSegue"
    static let ADD_COURSE_SEGUE = "addCourseSegue"
    static let SHOW_COURSE_DETAIL_SEGUE_IDENTIFIER = "showCourseDetailSegue"
    
    // Cell Identifier
    static let COURSE_CELL_IDENTIFIER = "courseCell"
    static let GRAGE_TABLE_CELL_IDENTIFIER = "gradeCell"
    
}
