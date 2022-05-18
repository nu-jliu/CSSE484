//
//  GradeSideViewController.swift
//  Rose Grade Tracker
//
//  Created by Jingkun Liu on 5/17/22.
//

import UIKit

class GradeSideViewController: UIViewController {

    @IBOutlet weak var deletePartButton: UIButton!
    @IBOutlet weak var addPartButton: UIButton!
    
    @IBOutlet weak var deleteAssignButton: UIButton!
    @IBOutlet weak var deleteExamButton: UIButton!
    @IBOutlet weak var deleteLabButton: UIButton!
    @IBOutlet weak var deleteQuizButton: UIButton!
    
    var courseDetailViewController: CourseDetailViewController {
        let navController = self.presentingViewController as! UINavigationController
        return navController.viewControllers.last as! CourseDetailViewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.deletePartButton.isHidden = CourseDocumentManager.shared.latestCourse?.partWeight == nil
        self.addPartButton.isHidden = CourseDocumentManager.shared.latestCourse?.partWeight != nil
        
        self.deleteAssignButton.isHidden = CourseDocumentManager.shared.latestCourse!.assignmentsGrade.isEmpty
        self.deleteExamButton.isHidden = CourseDocumentManager.shared.latestCourse!.examsGrade.isEmpty
        self.deleteLabButton.isHidden = CourseDocumentManager.shared.latestCourse!.labsGrade.isEmpty
        self.deleteQuizButton.isHidden = CourseDocumentManager.shared.latestCourse!.quizzesGrade.isEmpty
    }
    
    @IBAction func deletePartPressed(_ sender: Any) {
        self.dismiss(animated: true)
        CourseDocumentManager.shared.removeGrade(type: .participation)
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
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
