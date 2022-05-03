//
//  Utils.swift
//  Rose Grade Tracker
//
//  Created by Jingkun Liu on 4/30/22.
//

import Foundation
import Firebase

class Utils {
    
    static func parseGradeToLetter(grade: Double) -> String {
        if grade >= 90 {
            return "A"
        }
        
        if grade >= 85 {
            return "B+"
        }
        
        if grade >= 80 {
            return "B"
        }
        
        if grade >= 75 {
            return "C+"
        }
        
        if grade >= 70 {
            return "C"
        }
        
        if grade >= 65 {
            return "D+"
        }
        
        if grade >= 60 {
            return "D"
        }
        
        return "F"
    }
    
    static func parseQuarter(quarter: Int) -> String {
        switch quarter {
        case 1:
            return "Fall"
        case 2:
            return "Winter"
        case 3:
            return "Spring"
        case 4:
            return "Summer"
        default:
            return "N/A"
        }
    }
    
    static func calculateTotal(course: Course) -> (grade: Double, weight: Int) {
        var totalWeight = 0
        var totalGrade = 0.0
        
        if let partWeight = course.partWeight {
            totalWeight += partWeight
            totalGrade += course.partGrade! / 100.0 * Double(partWeight)
        }
        
        if let assignWeight = course.assignmentsWeight {
            if !course.assignmentsGrade.isEmpty {
                totalWeight += assignWeight
                totalGrade += self.calcTotalGradeWeight(grades: course.assignmentsGrade, weight: assignWeight).grade
            }
        }
        
        if let examsWeight = course.examsWeight {
            if !course.examsGrade.isEmpty {
                totalWeight += examsWeight
                totalGrade += self.calcTotalGradeWeight(grades: course.examsGrade, weight: examsWeight).grade
            }
        }
        
        if let labsWeight = course.labsWeight {
            if !course.labsGrade.isEmpty {
                totalWeight += labsWeight
                totalGrade += self.calcTotalGradeWeight(grades: course.labsGrade, weight: labsWeight).grade
            }
        }
        
        if let quizzesWeight = course.examsWeight {
            if !course.examsGrade.isEmpty {
                totalWeight += quizzesWeight
                totalGrade += self.calcTotalGradeWeight(grades: course.quizzesGrade, weight: quizzesWeight).grade
            }
        }
        
        return (totalGrade / Double(totalWeight) * 100.0, totalWeight)
    }
    
    static func calcTotalGradeWeight(grades: [(weight: Int, grade: Double, displayName: String)], weight: Int) -> (grade: Double, weight: Int) {
        var totalGrade = 0.0
        var totalWeight = 0
        
        for gradeEntry in grades {
            let grade = gradeEntry.grade
            let weight = gradeEntry.weight
            
            totalWeight += weight
            totalGrade += grade / 100.0 * Double(weight)
        }
        
        return (totalGrade / Double(totalWeight) * Double(weight), totalWeight)
    }
    
    static func getNumRows(course: Course) -> [(SectionLabel, Int)] {
        var numRows = [(SectionLabel, Int)]()
        
        if course.partGrade != nil {
            numRows.append((.participation, 1))
        }
        
        if !course.assignmentsGrade.isEmpty {
            numRows.append((.assignments, course.assignmentsGrade.count))
        }
        
        if !course.examsGrade.isEmpty {
            numRows.append((.exams, course.examsGrade.count))
        }
        
        if !course.labsGrade.isEmpty {
            numRows.append((.labs, course.labsGrade.count))
        }
        
        if !course.quizzesGrade.isEmpty {
            numRows.append((.quizzes, course.quizzesGrade.count))
        }
        
        return numRows
    }
}
