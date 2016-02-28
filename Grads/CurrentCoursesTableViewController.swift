//
//  CurrentCoursesTableViewController.swift
//  Grads
//
//  Created by Lucas Tenório on 17/02/16.
//  Copyright © 2016 lvt. All rights reserved.
//

import UIKit

class CurrentCoursesTableViewController: UITableViewController {

  var courses = Array<Course>()
  override func viewWillAppear(animated: Bool) {
    self.reloadCourses()
    self.tableView.reloadData()
  }
  func reloadCourses() {
        courses = CourseController.sharedController.selectedCourses.sort{ $0.name < $1.name }
  }
  override func viewDidLoad() {
    super.viewDidLoad()

    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = false

    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    self.navigationItem.leftBarButtonItem = self.editButtonItem()
  }

  // MARK: - Table view data source

  override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return 1
  }

  override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return courses.count
  }

  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("Courses", forIndexPath: indexPath)
    let course = courses[indexPath.row]
    cell.textLabel?.text = course.name
    cell.detailTextLabel?.text = course.code
    cell.accessoryType = .DisclosureIndicator
    return cell
  }




  // Override to support editing the table view.
  override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
    if editingStyle == .Delete {
      do {
        try CourseController.sharedController.deselectCourse(self.courses[indexPath.row])
        self.reloadCourses()
        tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
      } catch {
      }
    }
  }


  /*
  // Override to support rearranging the table view.
  override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

  }
  */

  /*
  // Override to support conditional rearranging of the table view.
  override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
  // Return false if you do not want the item to be re-orderable.
  return true
  }
  */

  /*
  // MARK: - Navigation

  // In a storyboard-based application, you will often want to do a little preparation before navigation
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
  // Get the new view controller using segue.destinationViewController.
  // Pass the selected object to the new view controller.
  }
  */

}
