//
//  Utils.swift
//  Rose Grade Tracker
//
//  Created by Jingkun Liu on 4/30/22.
//

import Foundation
import Firebase
import UIKit
import Kingfisher

class Utils {
    
    static func parseGradeToLetter(grade: Double) -> (letter: String, point: Double) {
        if grade >= 90 {
            return ("A", 4.0)
        }
        
        if grade >= 85 {
            return ("B+", 3.5)
        }
        
        if grade >= 80 {
            return ("B", 3.0)
        }
        
        if grade >= 75 {
            return ("C+", 2.5)
        }
        
        if grade >= 70 {
            return ("C", 2.0)
        }
        
        if grade >= 65 {
            return ("D+", 1.5)
        }
        
        if grade >= 60 {
            return ("D", 1.0)
        }
        
        return ("F", 0.0)
    }
    
    static func parseQuarter(quarter: Int) -> String {
        let language = Locale.autoupdatingCurrent.languageCode
        
        switch quarter {
        case 1:
            if language == "zh" {
                return "秋"
            }
            return "Fall"
        case 2:
            if language == "zh" {
                return "冬"
            }
            return "Winter"
        case 3:
            if language == "zh" {
                return "春"
            }
            return "Spring"
        case 4:
            if language == "zh" {
                return "夏"
            }
            return "Summer"
        default:
            return "N/A"
        }
    }
    
    static func quarterStrToNum(_ quarterStr: String) -> Int {
        if quarterStr == "Fall" {
            return 1
        }
        
        if quarterStr == "Winter" {
            return 2
        }
        
        if quarterStr == "Spring" {
            return 3
        }
        
        if quarterStr == "Summer" {
            return 4
        }
        
        return -1
    }
    
    static func calculateTotal(course: Course) -> (grade: Double, weight: Int) {
        var totalWeight = 0
        var totalGrade = 0.0
        
        if let partWeight = course.partWeight {
            totalWeight += partWeight
            totalGrade += (course.partGrade ?? 0) / 100.0 * Double(partWeight)
        }
        
        if let assignWeight = course.assignmentsWeight {
            if !course.assignmentsGrade.isEmpty {
                totalWeight += assignWeight
                totalGrade += self.calcTotalGradeWeight(
                    grades: course.assignmentsGrade,
                    weight: assignWeight
                ).grade
            }
        }
        
        if let examsWeight = course.examsWeight {
            if !course.examsGrade.isEmpty {
                totalWeight += examsWeight
                totalGrade += self.calcTotalGradeWeight(
                    grades: course.examsGrade,
                    weight: examsWeight
                ).grade
            }
        }
        
        if let labsWeight = course.labsWeight {
            if !course.labsGrade.isEmpty {
                totalWeight += labsWeight
                totalGrade += self.calcTotalGradeWeight(
                    grades: course.labsGrade,
                    weight: labsWeight
                ).grade
            }
        }
        
        if let quizzesWeight = course.quizzesWeight {
            if !course.quizzesGrade.isEmpty {
                totalWeight += quizzesWeight
                totalGrade += self.calcTotalGradeWeight(
                    grades: course.quizzesGrade,
                    weight: quizzesWeight
                ).grade
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
        
        print(grades)
        print("total: \(totalGrade)")
        
        return (totalGrade / Double(totalWeight) * Double(weight), totalWeight)
    }
    
    static func getNumRows(course: Course) -> [(GradeType, Int)] {
        var numRows = [(GradeType, Int)]()
        
        if course.partWeight != nil {
            numRows.append((.participation, 1))
        }
        
        if !course.assignmentsGrade.isEmpty && course.assignmentsWeight != nil {
            numRows.append((.assignments, course.assignmentsGrade.count))
        }
        
        if !course.examsGrade.isEmpty && course.examsWeight != nil {
            numRows.append((.exams, course.examsGrade.count))
        }
        
        if !course.labsGrade.isEmpty && course.labsWeight != nil {
            numRows.append((.labs, course.labsGrade.count))
        }
        
        if !course.quizzesGrade.isEmpty && course.quizzesWeight != nil {
            numRows.append((.quizzes, course.quizzesGrade.count))
        }
        
        return numRows
    }
    
    static func calcCumGPA(currGPA: Double, currCred: Int, courses: [Course]) -> (credits: Int, GPA: Double) {
        var cumPoint = currGPA * Double(currCred)
        var cumCred = Double(currCred)
        
        for course in courses {
            let grade = self.calculateTotal(course: course).grade
            let credit = Double(course.credit)
            
            let point = self.parseGradeToLetter(grade: grade).point
            
            cumCred += credit
            cumPoint += credit * point
        }
        
        return (Int(cumCred), cumPoint/cumCred)
    }
    
    static func load(imageView: UIImageView, from url: String) {
        if let imgUrl = URL(string: url) {
            imageView.kf.setImage(with: imgUrl)
        }
    }
    
    // From https://stackoverflow.com/questions/29726643/how-to-compress-of-reduce-the-size-of-an-image-before-uploading-to-parse-as-pffi
    static func resize(image: UIImage, maxHeight: Float = 200.0, maxWidth: Float = 200.0, compressionQuality: Float = 0.5) -> Data? {
        var actualHeight: Float = Float(image.size.height)
        var actualWidth: Float = Float(image.size.width)
        var imgRatio: Float = actualWidth / actualHeight
        let maxRatio: Float = maxWidth / maxHeight
        
        if actualHeight > maxHeight || actualWidth > maxWidth {
            if imgRatio < maxRatio {
                //adjust width according to maxHeight
                imgRatio = maxHeight / actualHeight
                actualWidth = imgRatio * actualWidth
                actualHeight = maxHeight
            }
            else if imgRatio > maxRatio {
                //adjust height according to maxWidth
                imgRatio = maxWidth / actualWidth
                actualHeight = imgRatio * actualHeight
                actualWidth = maxWidth
            }
            else {
                actualHeight = maxHeight
                actualWidth = maxWidth
            }
        }
        let rect = CGRect(x: 0.0, y: 0.0, width: CGFloat(actualWidth), height: CGFloat(actualHeight))
        UIGraphicsBeginImageContext(rect.size)
        image.draw(in:rect)
        let img = UIGraphicsGetImageFromCurrentImageContext()
        let imageData = img!.jpegData(compressionQuality: CGFloat(compressionQuality))
        UIGraphicsEndImageContext()
        return imageData
    }
    
    static func cropImageToSquare(image: UIImage) -> UIImage? {
        var imageHeight = image.size.height
        var imageWidth = image.size.width
        
        if imageHeight > imageWidth {
            imageHeight = imageWidth
        }
        else {
            imageWidth = imageHeight
        }
        
        let size = CGSize(width: imageWidth, height: imageHeight)
        
        let refWidth : CGFloat = CGFloat(image.cgImage!.width)
        let refHeight : CGFloat = CGFloat(image.cgImage!.height)
        
        let x = (refWidth - size.width) / 2
        let y = (refHeight - size.height) / 2
        
        let cropRect = CGRect(x: x, y: y, width: size.height, height: size.width)
        if let imageRef = image.cgImage?.cropping(to: cropRect) {
            return UIImage(cgImage: imageRef, scale: 0, orientation: image.imageOrientation)
        }
        
        return nil
    }
}
