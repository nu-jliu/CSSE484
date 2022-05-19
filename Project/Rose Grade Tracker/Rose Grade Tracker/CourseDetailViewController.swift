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
    
    var numRows = [(GradeType, Int)]()
    var sumWeight: Double?
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .darkContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.gradeDetailTableView.dataSource = self
        self.gradeDetailTableView.delegate = self
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
        if
            let name = CourseDocumentManager.shared.latestCourse?.name,
            let number = CourseDocumentManager.shared.latestCourse?.number {
            self.navigationItem.title = "\(number) \(name)"
        }
        
        let overallGrade = Utils.calculateTotal(course: CourseDocumentManager.shared.latestCourse!)
        self.overallGradeLabel.text = String(format: "%.2f", overallGrade.grade)
        self.overallLetterGradeLabel.text = Utils.parseGradeToLetter(grade: overallGrade.grade).letter
        
        self.gradeDetailTableView.reloadData()
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
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

// MARK: - Table View Data Source

extension CourseDetailViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.numRows[section].1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.gradeDetailTableView.dequeueReusableCell(
            withIdentifier: Constants.GRAGE_TABLE_CELL_IDENTIFIER,
            for: indexPath
        ) as! GradeTableCell
        
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
                cell.gradeLabel.text = "\(String(format: "%.1f", course.partGrade ?? 0.0))"
                cell.letterGradeLabel.text = Utils.parseGradeToLetter(grade: course.partGrade ?? 0.0).letter
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Selected row at section: \(indexPath.section), row: \(indexPath.row)")
        
        switch self.numRows[indexPath.section].0 {
        case .participation:
            
            let alertController = UIAlertController(
                title: "Edit Participation Grade",
                message: "Enter new Participation Grade",
                preferredStyle: .alert
            )
            
            alertController.addTextField { textfield in
                textfield.placeholder = "Grade"
                
                if let grade = CourseDocumentManager.shared.latestCourse?.partGrade {
                    textfield.text = "\(grade)"
                }
            }
            
            alertController.addTextField { textfield in
                textfield.placeholder = "Weight"
                
                if let weight = CourseDocumentManager.shared.latestCourse?.partWeight {
                    textfield.text = "\(weight)"
                }
            }
            
            alertController.addAction(UIAlertAction(
                title: "Submit",
                style: .default
            ) { action in
                
                let grade = Double(alertController.textFields![0].text ?? "") ?? 0.0
                let weight = Int(alertController.textFields![1].text ?? "") ?? 0

                
                CourseDocumentManager.shared.updateParticipation(grade: grade, weight: weight)
                
            })
            
            alertController.addAction(UIAlertAction(
                title: "Cancel",
                style: .cancel
            ))
            
            self.present(alertController, animated: true)
        case .assignments:
            if var assignments = CourseDocumentManager.shared.latestCourse?.assignmentsGrade {
                var assignment = assignments[indexPath.row]
                
                let alertController = UIAlertController(
                    title: "Assignment Grade",
                    message: "Enter New Grade",
                    preferredStyle: .alert
                )
                
                alertController.addTextField { textfield in
                    textfield.placeholder = "Name"
                    textfield.text = assignment.displayName
                }
                
                alertController.addTextField { textfield in
                    textfield.placeholder = "Grade"
                    textfield.text = "\(assignment.grade)"
                }
                
                alertController.addTextField { textfield in
                    textfield.placeholder = "Weight"
                    textfield.text = "\(assignment.weight)"
                }
                
                alertController.addAction(UIAlertAction(title: "Submit", style: .default) { action in
                    let name = alertController.textFields?[0].text ?? ""
                    let grade = Double(alertController.textFields?[1].text ?? "") ?? 0.0
                    let weight = Int(alertController.textFields?[2].text ?? "") ?? 0
                    
                    assignment.displayName = name
                    assignment.grade = grade
                    assignment.weight = weight
                    
                    assignments[indexPath.row] = assignment
                    
                    CourseDocumentManager.shared.updateGrade(type: .assignments, grades: assignments)
                })
                
                alertController.addAction(UIAlertAction(
                    title: "Cancel",
                    style: .cancel
                ))
                
                self.present(alertController, animated: true)
            }
        case .exams:
            if var exams = CourseDocumentManager.shared.latestCourse?.examsGrade {
                var exam = exams[indexPath.row]
                
                let alertController = UIAlertController(
                    title: "Exam Grade",
                    message: "Enter New Grade",
                    preferredStyle: .alert
                )
                
                alertController.addTextField { textfield in
                    textfield.placeholder = "Name"
                    textfield.text = exam.displayName
                }
                
                alertController.addTextField { textfield in
                    textfield.placeholder = "Grade"
                    textfield.text = "\(exam.grade)"
                }
                
                alertController.addTextField { textfield in
                    textfield.placeholder = "Weight"
                    textfield.text = "\(exam.weight)"
                }
                
                alertController.addAction(UIAlertAction(
                    title: "Submit",
                    style: .default
                ) { action in
                    let name = alertController.textFields?[0].text ?? ""
                    let grade = Double(alertController.textFields?[1].text ?? "") ?? 0.0
                    let weight = Int(alertController.textFields?[2].text ?? "") ?? 0
                    
                    exam.displayName = name
                    exam.grade = grade
                    exam.weight = weight
                    
                    exams[indexPath.row] = exam
                    
                    CourseDocumentManager.shared.updateGrade(type: .exams, grades: exams)
                })
                
                alertController.addAction(UIAlertAction(
                    title: "Cancel",
                    style: .cancel
                ))
                
                self.present(alertController, animated: true)
            }
        case .labs:
            if var labs = CourseDocumentManager.shared.latestCourse?.labsGrade {
                var lab = labs[indexPath.row]
                
                let alertController = UIAlertController(
                    title: "Lab Grade",
                    message: "Enter New Grade",
                    preferredStyle: .alert
                )
                
                alertController.addTextField { textfield in
                    textfield.placeholder = "Name"
                    textfield.text = lab.displayName
                }
                
                alertController.addTextField { textfield in
                    textfield.placeholder = "Grade"
                    textfield.text = "\(lab.grade)"
                }
                
                alertController.addTextField { textfield in
                    textfield.placeholder = "Weight"
                    textfield.text = "\(lab.weight)"
                }
                
                alertController.addAction(UIAlertAction(
                    title: "Submit",
                    style: .default
                ) { action in
                    let name = alertController.textFields?[0].text ?? ""
                    let grade = Double(alertController.textFields?[1].text ?? "") ?? 0.0
                    let weight = Int(alertController.textFields?[2].text ?? "") ?? 0
                    
                    lab.displayName = name
                    lab.grade = grade
                    lab.weight = weight

                    labs[indexPath.row] = lab
                    
                    CourseDocumentManager.shared.updateGrade(type: .labs, grades: labs)
                })
                
                alertController.addAction(UIAlertAction(
                    title: "Cancel",
                    style: .cancel
                ))
                
                self.present(alertController, animated: true)
            }
        case .quizzes:
            if var quizzes = CourseDocumentManager.shared.latestCourse?.quizzesGrade {
                var quiz = quizzes[indexPath.row]
                
                let alertController = UIAlertController(
                    title: "Quiz Grade",
                    message: "Enter New Grade",
                    preferredStyle: .alert
                )
                
                alertController.addTextField { textfield in
                    textfield.placeholder = "Name"
                    textfield.text = quiz.displayName
                }
                
                alertController.addTextField { textfield in
                    textfield.placeholder = "Grade"
                    textfield.text = "\(quiz.grade)"
                }
                
                alertController.addTextField { textfield in
                    textfield.placeholder = "Weight"
                    textfield.text = "\(quiz.weight)"
                }
                
                alertController.addAction(UIAlertAction(
                    title: "Submit",
                    style: .default
                ) { action in
                    let name = alertController.textFields?[0].text ?? ""
                    let grade = Double(alertController.textFields?[1].text ?? "") ?? 0.0
                    let weight = Int(alertController.textFields?[2].text ?? "") ?? 0
                    
                    quiz.displayName = name
                    quiz.grade = grade
                    quiz.weight = weight
                    
                    quizzes[indexPath.row] = quiz
                    
                    CourseDocumentManager.shared.updateGrade(type: .quizzes, grades: quizzes)
                })
                
                alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel))
                
                self.present(alertController, animated: true)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let type = self.numRows[indexPath.section].0
            
            switch type {
            case .participation:
                CourseDocumentManager.shared.removeGrade(type: type)
            case .assignments:
                if var grades = CourseDocumentManager.shared.latestCourse?.assignmentsGrade {
                    grades.remove(at: indexPath.row)
                    
                    if grades.isEmpty {
                        CourseDocumentManager.shared.removeGrade(type: type)
                    } else {
                        CourseDocumentManager.shared.updateGrade(type: type, grades: grades)
                    }
                }
            case .exams:
                if var grades = CourseDocumentManager.shared.latestCourse?.examsGrade {
                    grades.remove(at: indexPath.row)
                    
                    if grades.isEmpty {
                        CourseDocumentManager.shared.removeGrade(type: type)
                    } else {
                        CourseDocumentManager.shared.updateGrade(type: type, grades: grades)
                    }
                }
            case .labs:
                if var grades = CourseDocumentManager.shared.latestCourse?.labsGrade {
                    grades.remove(at: indexPath.row)
                    
                    if grades.isEmpty {
                        CourseDocumentManager.shared.removeGrade(type: type)
                    } else {
                        CourseDocumentManager.shared.updateGrade(type: type, grades: grades)
                    }
                }
            case .quizzes:
                if var grades = CourseDocumentManager.shared.latestCourse?.quizzesGrade {
                    grades.remove(at: indexPath.row)
                    
                    if grades.isEmpty {
                        CourseDocumentManager.shared.removeGrade(type: type)
                    } else {
                        CourseDocumentManager.shared.updateGrade(type: type, grades: grades)
                    }
                }
            }
        }
    }
}
