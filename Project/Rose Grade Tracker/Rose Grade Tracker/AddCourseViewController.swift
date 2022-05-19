//
//  AddCourseViewController.swift
//  Rose Grade Tracker
//
//  Created by Jingkun Liu on 5/18/22.
//

import UIKit

class AddCourseViewController: UIViewController {

    // text fields
    @IBOutlet weak var yearTextField: UITextField!
    @IBOutlet weak var quarterTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var sectionTextField: UITextField!
    @IBOutlet weak var courseNumberTextField: UITextField!
    @IBOutlet weak var courseCreditsTextField: UITextField!
    @IBOutlet weak var participationWeightTextField: UITextField!
    @IBOutlet weak var assignmentsWeightTextField: UITextField!
    @IBOutlet weak var examsWeightTextField: UITextField!
    @IBOutlet weak var labsWeightTextField: UITextField!
    @IBOutlet weak var quizzesWeightTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func comfirmPressed(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
        
        guard
            let year = Int(self.yearTextField.text ?? ""),
            let quarter = self.quarterTextField.text,
            let name = self.nameTextField.text,
            let section = Int(self.sectionTextField.text ?? ""),
            let number = self.courseNumberTextField.text,
            let credits = Int(self.courseCreditsTextField.text ?? "")
        else {
            print("ERROR: invalid input")
            return
        }
        
        print("success")
        
        let course = Course(
            name: name,
            number: number,
            section: section,
            quarter: Utils.quarterStrToNum(quarter),
            year: year,
            credits: credits
        )
        
        course.partWeight = Int(self.participationWeightTextField.text ?? "")
        course.assignmentsWeight = Int(self.assignmentsWeightTextField.text ?? "")
        course.examsWeight = Int(self.examsWeightTextField.text ?? "")
        course.labsWeight = Int(self.labsWeightTextField.text ?? "")
        course.quizzesWeight = Int(self.quizzesWeightTextField.text ?? "")
        
        CoursesCollectionManager.shared.add(course)
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
