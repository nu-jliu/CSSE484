//
//  GradeSideViewController.swift
//  Rose Grade Tracker
//
//  Created by Jingkun Liu on 5/17/22.
//

import UIKit

class GradeSideViewController: UIViewController {

    @IBOutlet weak var addPartButton: UIButton!
    @IBOutlet weak var addAssignmentButton: UIButton!
    @IBOutlet weak var addExamsButton: UIButton!
    @IBOutlet weak var addLabButton: UIButton!
    @IBOutlet weak var addQuizButton: UIButton!
    
    var courseDetailViewController: CourseDetailViewController {
        let navController = self.presentingViewController as! UINavigationController
        return navController.viewControllers.last as! CourseDetailViewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.addPartButton.isHidden = CourseDocumentManager.shared.latestCourse?.partWeight != nil
        self.addAssignmentButton.isHidden = CourseDocumentManager.shared.latestCourse?.assignmentsWeight == nil
        self.addExamsButton.isHidden = CourseDocumentManager.shared.latestCourse?.examsWeight == nil
        self.addLabButton.isHidden = CourseDocumentManager.shared.latestCourse?.labsWeight == nil
        self.addQuizButton.isHidden = CourseDocumentManager.shared.latestCourse?.quizzesWeight == nil
    }
    
    @IBAction func deleteGradesPressed(_ sender: Any) {
        self.dismiss(animated: true)
        self.courseDetailViewController.gradeDetailTableView.isEditing = true
    }
    
    @IBAction func doneEditingPressed(_ sender: Any) {
        self.dismiss(animated: true)
        self.courseDetailViewController.gradeDetailTableView.isEditing = false
    }
    
    @IBAction func addPartPressed(_ sender: Any) {
        self.dismiss(animated: true)
        
        let alertController = UIAlertController(
            title: "Add Participation",
            message: "Enter Grade",
            preferredStyle: .alert
        )
        
        alertController.addTextField { textfield in
            textfield.placeholder = "Weight"
        }
        
        alertController.addTextField { textfield in
            textfield.placeholder = "Grade"
        }
        
        alertController.addAction(UIAlertAction(
            title: "Submit",
            style: .default
        ) { action in
            let weight = Int(alertController.textFields?[0].text ?? "") ?? 0
            let grade = Double(alertController.textFields?[1].text ?? "") ?? 0.0
            
            CourseDocumentManager.shared.updateParticipation(grade: grade, weight: weight)
        })
        
        alertController.addAction(UIAlertAction(
            title: "Cancel",
            style: .cancel
        ))
        
        self.courseDetailViewController.present(alertController, animated: true)
    }
    
    @IBAction func addAssignPressed(_ sender: Any) {
        self.dismiss(animated: true)
        
        if var grades = CourseDocumentManager.shared.latestCourse?.assignmentsGrade {
            let alertController = UIAlertController(
                title: "New Assignment",
                message: "Enter Grade",
                preferredStyle: .alert
            )
            
            alertController.addTextField { textfield in
                textfield.placeholder = "Name"
            }
            
            alertController.addTextField { textfield in
                textfield.placeholder = "Grade"
            }
            
            alertController.addTextField { textfield in
                textfield.placeholder = "Weight"
            }
            
            alertController.addAction(UIAlertAction(
                title: "Cancel",
                style: .cancel
            ))
            
            alertController.addAction(UIAlertAction(
                title: "Add",
                style: .default
            ) { action in
                let name = alertController.textFields?[0].text ?? ""
                let grade = Double(alertController.textFields?[1].text ?? "") ?? 0.0
                let weight = Int(alertController.textFields?[2].text ?? "") ?? 0
                
                grades.append((weight, grade, name))
                
                CourseDocumentManager.shared.updateGrade(type: .assignments, grades: grades)
            })
            
            self.courseDetailViewController.present(alertController, animated: true)
        }
    }
    
    @IBAction func addExamPressed(_ sender: Any) {
        self.dismiss(animated: true)
        
        if var grades = CourseDocumentManager.shared.latestCourse?.examsGrade {
            let alertController = UIAlertController(
                title: "New Exam",
                message: "Enter Grade",
                preferredStyle: .alert
            )
            
            alertController.addTextField { textfield in
                textfield.placeholder = "Name"
            }
            
            alertController.addTextField { textfield in
                textfield.placeholder = "Grade"
            }
            
            alertController.addTextField { textfield in
                textfield.placeholder = "Weight"
            }
            
            alertController.addAction(UIAlertAction(
                title: "Cancel",
                style: .cancel
            ))
            
            alertController.addAction(UIAlertAction(
                title: "Add",
                style: .default
            ) { action in
                let name = alertController.textFields?[0].text ?? ""
                let grade = Double(alertController.textFields?[1].text ?? "") ?? 0.0
                let weight = Int(alertController.textFields?[2].text ?? "") ?? 0
                
                grades.append((weight, grade, name))
                
                CourseDocumentManager.shared.updateGrade(type: .exams, grades: grades)
            })
            
            self.courseDetailViewController.present(alertController, animated: true)
        }
    }
    
    @IBAction func addLabPressed(_ sender: Any) {
        self.dismiss(animated: true)
        
        if var grades = CourseDocumentManager.shared.latestCourse?.labsGrade {
            let alertController = UIAlertController(
                title: "New Lab",
                message: "Enter Grade",
                preferredStyle: .alert
            )
            
            alertController.addTextField { textfield in
                textfield.placeholder = "Name"
            }
            
            alertController.addTextField { textfield in
                textfield.placeholder = "Grade"
            }
            
            alertController.addTextField { textfield in
                textfield.placeholder = "Weight"
            }
            
            alertController.addAction(UIAlertAction(
                title: "Cancel",
                style: .cancel
            ))
            
            alertController.addAction(UIAlertAction(
                title: "Add",
                style: .default
            ) { action in
                let name = alertController.textFields?[0].text ?? ""
                let grade = Double(alertController.textFields?[1].text ?? "") ?? 0.0
                let weight = Int(alertController.textFields?[2].text ?? "") ?? 0
                
                grades.append((weight, grade, name))
                
                CourseDocumentManager.shared.updateGrade(type: .labs, grades: grades)
            })
            
            self.courseDetailViewController.present(alertController, animated: true)
        }
    }
    
    @IBAction func addQuizPressed(_ sender: Any) {
        self.dismiss(animated: true)
        
        if var grades = CourseDocumentManager.shared.latestCourse?.quizzesGrade {
            let alertController = UIAlertController(
                title: "New Assignment",
                message: "Enter Grade",
                preferredStyle: .alert
            )
            
            alertController.addTextField { textfield in
                textfield.placeholder = "Name"
            }
            
            alertController.addTextField { textfield in
                textfield.placeholder = "Grade"
            }
            
            alertController.addTextField { textfield in
                textfield.placeholder = "Weight"
            }
            
            alertController.addAction(UIAlertAction(
                title: "Cancel",
                style: .cancel
            ))
            
            alertController.addAction(UIAlertAction(
                title: "Add",
                style: .default
            ) { action in
                let name = alertController.textFields?[0].text ?? ""
                let grade = Double(alertController.textFields?[1].text ?? "") ?? 0.0
                let weight = Int(alertController.textFields?[2].text ?? "") ?? 0
                
                grades.append((weight, grade, name))
                
                CourseDocumentManager.shared.updateGrade(type: .quizzes, grades: grades)
            })
            
            self.courseDetailViewController.present(alertController, animated: true)
        }
    }
    
    @IBAction func editWeightsPressed(_ sender: Any) {
        self.dismiss(animated: true)
        
        let alertController = UIAlertController(
            title: "Edit Weights",
            message: "Enter New Weights",
            preferredStyle: .alert
        )
        
        alertController.addTextField { textfield in
            textfield.placeholder = "Participation Weight"
            if let weight = CourseDocumentManager.shared.latestCourse?.partWeight {
                textfield.text = "\(weight)"
            }
        }
        
        alertController.addTextField { textfield in
            textfield.placeholder = "Assignments Weight"
            if let weight = CourseDocumentManager.shared.latestCourse?.assignmentsWeight {
                textfield.text = "\(weight)"
            }
        }
        
        alertController.addTextField { textfield in
            textfield.placeholder = "Exams Weight"
            if let weight = CourseDocumentManager.shared.latestCourse?.examsWeight {
                textfield.text = "\(weight)"
            }
        }
        
        alertController.addTextField { textfield in
            textfield.placeholder = "Labs Weight"
            if let weight = CourseDocumentManager.shared.latestCourse?.labsWeight {
                textfield.text = "\(weight)"
            }
        }
        
        alertController.addTextField { textfield in
            textfield.placeholder = "Quizzes Weight"
            if let weight = CourseDocumentManager.shared.latestCourse?.quizzesWeight {
                textfield.text = "\(weight)"
            }
        }
        
        alertController.addAction(UIAlertAction(
            title: "Cancel",
            style: .cancel
        ))
        
        alertController.addAction(UIAlertAction(
            title: "Confirm",
            style: .default
        ) { action in
            let partWeight = Int(alertController.textFields?[0].text ?? "")
            let assignWeight = Int(alertController.textFields?[1].text ?? "")
            let examsWeight = Int(alertController.textFields?[2].text ?? "")
            let labsWeight = Int(alertController.textFields?[3].text ?? "")
            let quizzesWeight = Int(alertController.textFields?[4].text ?? "")
            
            
            CourseDocumentManager.shared.updateWeight(type: .participation, weight: partWeight)
            CourseDocumentManager.shared.updateWeight(type: .assignments, weight: assignWeight)
            CourseDocumentManager.shared.updateWeight(type: .exams, weight: examsWeight)
            CourseDocumentManager.shared.updateWeight(type: .labs, weight: labsWeight)
            CourseDocumentManager.shared.updateWeight(type: .quizzes, weight: quizzesWeight)
        })
        
        self.courseDetailViewController.present(
            alertController,
            animated: true
        )
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
