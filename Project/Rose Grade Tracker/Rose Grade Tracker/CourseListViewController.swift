//
//  CourseListViewController.swift
//  Rose Grade Tracker
//
//  Created by Jingkun Liu on 4/30/22.
//

import UIKit
import Firebase

class CourseTableCell: UITableViewCell {
    @IBOutlet weak var courseNameLabel: UILabel!
    @IBOutlet weak var couseSectionLabel: UILabel!
    @IBOutlet weak var courseGradeLabel: UILabel!
}

class CourseListViewController: UIViewController {
    
    @IBOutlet weak var menuButton: UIBarButtonItem!
    @IBOutlet weak var courseListTableView: UITableView!
    
    let COURSE_CELL_IDENTIFIER = "courseCell"
    let SHOW_COURSE_DETAIL_SEGUE_IDENTIFIER = "showCourseDetailSegue"
    
    var coursesListenerRegisteration: ListenerRegistration?
    var userListenerRegisteration: ListenerRegistration?
    var logoutHandle: AuthStateDidChangeListenerHandle?
    
    var profileImageButton: UIButton?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor : UIColor.white]
        self.courseListTableView.dataSource = self
        self.navigationItem.leftBarButtonItem = UIBarButtonItem()
//        self.navigationItem.rightBarButtonItem?.image = UIImage(named: "RH_G_HiRes-RGB-1c.png")
//        self.menuButton.image = UIImage(named: "RH_G_HiRes-RGB-1c.png")
//        let button: UIButton = UIButton(type: .custom)
//                //set image for button
//        button.setImage(UIImage(named: "RH_G_HiRes-RGB-1c.png"), for: .normal)
//                //add function for button
//
//        //set frame
//        button.frame = CGRect(x: 200, y: 0, width: 50, height: 50)
//
//        let barButton = UIBarButtonItem(customView: button)
//        //assign button to navigationbar
//        self.navigationItem.rightBarButtonItem = barButton
    }
    
    @objc func showMenu() {
        let alertController = UIAlertController(
            title: "Courses Options",
            message: nil,
            preferredStyle: .actionSheet
        )
        
        // sign out action
        alertController.addAction(UIAlertAction(
            title: "Sign Out",
            style: .destructive
        ) { action in
            AuthManager.shared.signOut()
        })
        
        alertController.addAction(UIAlertAction(
            title: "Cancel",
            style: .cancel
        ))
        
        self.present(alertController, animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.logoutHandle = AuthManager.shared.addLogoutObserver {
            self.navigationController?.popViewController(animated: true)
        }
        
        self.coursesListenerRegisteration = CoursesCollectionManager.shared.startListening(
            for: AuthManager.shared.currentUser!.uid
        ) {
            self.courseListTableView.reloadData()
        }
        
        self.userListenerRegisteration = UserDocumentManager.shared.startListening(for: AuthManager.shared.currentUser!.uid) {
            self.navigationItem.title = "Hi, \(UserDocumentManager.shared.name)!"
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        AuthManager.shared.removeObserver(self.logoutHandle)
        CoursesCollectionManager.shared.stopListening(self.coursesListenerRegisteration)
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == self.SHOW_COURSE_DETAIL_SEGUE_IDENTIFIER {
            let courseDetailVC = segue.destination as! CourseDetailViewController
            if let indexPath = self.courseListTableView.indexPathForSelectedRow {
                let course = CoursesCollectionManager.shared.latestCourses[indexPath.section][indexPath.row]
                courseDetailVC.coursDocumentId = course.documentId
            }
        }
    }
    

}

extension CourseListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.courseListTableView.dequeueReusableCell(withIdentifier: self.COURSE_CELL_IDENTIFIER, for: indexPath) as! CourseTableCell
        
        let course = CoursesCollectionManager.shared.latestCourses[indexPath.section][indexPath.row]
        cell.courseNameLabel.text = course.name
        cell.couseSectionLabel.text = course.section
        cell.courseGradeLabel.text = Utils.parseGradeToLetter(grade: Utils.calculateTotal(course: course).grade).letter
        
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return CoursesCollectionManager.shared.latestQuarters.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return CoursesCollectionManager.shared.latestCourses[section].count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return CoursesCollectionManager.shared.latestQuarters[section]
    }
    
    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        return "Total Number of Courses: \(CoursesCollectionManager.shared.latestCourses[section].count)"
    }
}
