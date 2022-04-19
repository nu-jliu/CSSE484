//
//  Course.swift
//  Rose Grade Tracker
//
//  Created by Jingkun Liu on 4/11/22.
//

import Foundation
import UIKit

class Course {
    var courseNumber: String
    var courseName: String
    var sectionNum: Int
    var grade: String
    
    init(courseNum: String, courseName: String, section: Int, grade: String) {
        self.courseNumber = courseNum
        self.courseName = courseName
        self.sectionNum = section
        self.grade = grade
    }
}
