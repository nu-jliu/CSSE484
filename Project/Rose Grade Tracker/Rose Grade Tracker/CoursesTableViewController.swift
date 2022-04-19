//
//  CoursesTableViewController.swift
//  Rose Grade Tracker
//
//  Created by Jingkun Liu on 4/11/22.
//

import UIKit

class CourseTableViewCell: UITableViewCell {
    
    @IBOutlet weak var courseNumberLabel: UILabel!
    @IBOutlet weak var courseNameLabel: UILabel!
    @IBOutlet weak var courseSectionLabel: UILabel!
    @IBOutlet weak var courseGradeLabel: UILabel!

}

class CoursesTableViewController: UITableViewController {

    let courseCellIdentifier = "CourseCell"
    
    var courses = [Course]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
//        self.navigationController?.topViewController?.view.backgroundColor = UIColor(red: 128, green: 0, blue: 0, alpha: 0)
        
        let navBar = self.navigationController!.navigationBar
        
        navBar.barStyle = .default
        navBar.backgroundColor = UIColor(red: 128, green: 0, blue: 0, alpha: 0)
        
        let course1 = Course(courseNum: "CSSE484", courseName: "iOS Application Development", section: 1, grade: "A")
        let course2 = Course(courseNum: "ME435", courseName: "Robotic Engineering", section: 2, grade: "B+")
        
        self.courses.append(course1)
        self.courses.append(course2)
    }
    // MARK: - Table view data source

//    override func numberOfSections(in tableView: UITableView) -> Int {
//        // #warning Incomplete implementation, return the number of sections
//        return
//    }

//    override var preferredStatusBarStyle: UIStatusBarStyle {
//        .lightContent
//    }
    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        let statusBarView = UIView(frame: UIApplication.shared.accessibilityFrame)
//        statusBarView.backgroundColor = UIColor(red: 128, green: 0, blue: 0, alpha: 0)
//        view.addSubview(statusBarView)
//    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.courses.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: self.courseCellIdentifier, for: indexPath) as! CourseTableViewCell

        // Configure the cell...
        let course = self.courses[indexPath.row]
        
        cell.courseNumberLabel.text = course.courseNumber
        cell.courseNameLabel.text = course.courseName
        cell.courseSectionLabel.text = String(format: "%02d", course.sectionNum)
        cell.courseGradeLabel.text = course.grade

        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
