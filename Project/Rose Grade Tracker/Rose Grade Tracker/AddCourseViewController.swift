//
//  AddCourseViewController.swift
//  Rose Grade Tracker
//
//  Created by Jingkun Liu on 5/18/22.
//

import UIKit
import Toast

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
    
    @IBOutlet weak var quarterPicker: UIPickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.quarterPicker.dataSource = self
        self.quarterPicker.delegate = self
        self.quarterPicker.isHidden = true
    }
    
    @IBAction func comfirmPressed(_ sender: Any) {
        
        guard
            let year = Int(self.yearTextField.text ?? ""),
            let quarter = self.quarterTextField.text,
            let name = self.nameTextField.text,
            let section = Int(self.sectionTextField.text ?? ""),
            let number = self.courseNumberTextField.text,
            let credits = Int(self.courseCreditsTextField.text ?? "")
        else {
            self.view.makeToast("Add failed: Invalid input")
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
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func quarterTextFieldTouchedInside(_ sender: Any) {
        self.quarterPicker.isHidden = false
    }
    
    
    @IBAction func quarterTextFieldTouchedOutside(_ sender: Any) {
        self.quarterPicker.isHidden = true
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

extension AddCourseViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        4
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch row {
        case 0:
            return "Fall"
        case 1:
            return "Winter"
        case 2:
            return "Spring"
        case 3:
            return "Summer"
        default:
            return ""
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.quarterTextField.text = self.pickerView(
            pickerView,
            titleForRow: row,
            forComponent: component
        )
    }
}
