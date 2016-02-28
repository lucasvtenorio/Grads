//
//  SelectCourseTableViewController.swift
//  Grads
//
//  Created by Lucas Tenório on 16/02/16.
//  Copyright © 2016 lvt. All rights reserved.
//

import UIKit

class SelectCourseTableViewController: UITableViewController {



  var availableCourses = CourseController.sharedController
    .availableCourses.sort { $0.name < $1.name }
  var notAvailableCourses = CourseController.sharedController
    .clashedCourses.sort { $0.name < $1.name }
  var courses =  Array<Array<Course>>()

  override func viewDidLoad() {
    super.viewDidLoad()
    self.courses = [availableCourses, notAvailableCourses]
  }

  // MARK: - Table view data source

  override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return self.courses.count
  }

  override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

    return self.courses[section].count
  }


  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("CourseReuseID", forIndexPath: indexPath)
    cell.textLabel?.text = self.courses[indexPath.section][indexPath.row].name
    cell.detailTextLabel?.text = self.courses[indexPath.section][indexPath.row].code
    // Configure the cell...
    cell.accessoryType = .DetailButton
    return cell
  }

  override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    return ["Cadeiras disponíveis", "Cadeiras não disponíveis"][section]
  }

  override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    print("cheguei aqui")
    let course = self.courses[indexPath.section][indexPath.row]
    do {
      try CourseController.sharedController.selectCourse(course)
      self.navigationController?.popViewControllerAnimated(true)
    } catch CourseController.Errors.CourseClashesWithCourse(let clashed){
      let controller = UIAlertController(title: "Conflito de horários", message: "A cadeira \(course.name) tem um conflito de horário com a cadeira \(clashed.name)", preferredStyle: .Alert)
      controller.addAction(UIAlertAction(title: "Ok", style: .Default, handler: nil))
      self.presentViewController(controller, animated: true, completion: nil)
    } catch {
      print("Deu merda selecionando saporra!")
    }
  }
  /*
  // Override to support conditional editing of the table view.
  override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
  // Return false if you do not want the specified item to be editable.
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
