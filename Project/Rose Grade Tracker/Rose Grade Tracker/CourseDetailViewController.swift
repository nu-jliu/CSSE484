//
//  CourseDetailViewController.swift
//  Rose Grade Tracker
//
//  Created by Jingkun Liu on 5/2/22.
//

import UIKit
import Firebase

class GradeTableCell: UITableViewCell {
    @IBOutlet weak var gradeItemNameLabel: UILabel!
    @IBOutlet weak var gradeWeightLabel: UILabel!
    @IBOutlet weak var gradeLabel: UILabel!
    @IBOutlet weak var letterGradeLabel: UILabel!
}

class CourseDetailViewController: UIViewController {

    @IBOutlet weak var gradeDetailTableView: UITableView!
    @IBOutlet weak var overallGradeLabel: UILabel!
    @IBOutlet weak var overallLetterGradeLabel: UILabel!
    
    var courseDetailListenerRegiteration: ListenerRegistration?
    var coursDocumentId: String?
    
    let GRAGE_TABLE_CELL = "gradeCell"
    var numRows = [(SectionLabel, Int)]()
    var sumWeight: Double?
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.gradeDetailTableView.dataSource = self
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.courseDetailListenerRegiteration = CourseDocumentManager.shared.startListening(for: self.coursDocumentId!) {
            self.numRows = Utils.getNumRows(course: CourseDocumentManager.shared.latestCourse!)
            self.sumWeight = Double(Utils.calculateTotal(course: CourseDocumentManager.shared.latestCourse!).weight)
            self.updateView()
            
            if let course = CourseDocumentManager.shared.latestCourse {
                print(course.quizzesGrade)
                print(course.labsGrade)
                print(course.assignmentsGrade)
            }
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        CourseDocumentManager.shared.stopListening(self.courseDetailListenerRegiteration)
    }
    
    func updateView() {
        self.tabBarItem.title = CourseDocumentManager.shared.latestCourse?.name
        let overallGrade = Utils.calculateTotal(course: CourseDocumentManager.shared.latestCourse!)
        self.overallGradeLabel.text = String(format: "%.2f", overallGrade.grade)
        self.overallLetterGradeLabel.text = Utils.parseGradeToLetter(grade: overallGrade.grade).letter
        
        self.gradeDetailTableView.reloadData()
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}


extension CourseDetailViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.numRows[section].1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.gradeDetailTableView.dequeueReusableCell(withIdentifier: self.GRAGE_TABLE_CELL, for: indexPath) as! GradeTableCell
        
        if let course = CourseDocumentManager.shared.latestCourse {
            var gradeEntry = [(weight: Int, grade: Double, displayName: String)]()
            var totalWeight: Int?
            
            switch self.numRows[indexPath.section].0 {
            case .assignments:
                gradeEntry = course.assignmentsGrade
                totalWeight = course.assignmentsWeight
            case .exams:
                gradeEntry = course.examsGrade
                totalWeight = course.examsWeight
            case .labs:
                gradeEntry = course.labsGrade
                totalWeight = course.labsWeight
            case .quizzes:
                gradeEntry = course.quizzesGrade
                totalWeight = course.quizzesWeight
            case .participation:
                cell.gradeItemNameLabel.text = "Participation Grade"
                cell.gradeWeightLabel.text = "\(String(format: "%.1f", Double(course.partWeight!) / self.sumWeight! * 100.0))%"
                cell.gradeLabel.text = "\(String(format: "%.1f", course.partGrade!))"
                cell.letterGradeLabel.text = Utils.parseGradeToLetter(grade: course.partGrade!).letter
                return cell
            }
            
            cell.gradeItemNameLabel.text = gradeEntry[indexPath.row].displayName
            
            let totalWeightRatio = Double(totalWeight!) / self.sumWeight!
            let weightRatio = Double(gradeEntry[indexPath.row].weight) / Double(Utils.calcTotalGradeWeight(grades: gradeEntry, weight: totalWeight!).weight)
            cell.gradeWeightLabel.text = "\(String(format: "%.1f", totalWeightRatio * weightRatio * 100))%"
            
            cell.gradeLabel.text = "\(String(format: "%.1f", gradeEntry[indexPath.row].grade))"
            cell.letterGradeLabel.text = Utils.parseGradeToLetter(grade: gradeEntry[indexPath.row].grade).letter
        }
        
        return cell
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.numRows.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.numRows[section].0.rawValue
    }
    
    
}

