//
//  ViewController.swift
//  Grads
//
//  Created by Lucas Tenório on 14/02/16.
//  Copyright © 2016 lvt. All rights reserved.
//

import UIKit

class ViewController: UIViewController, DataManager {
  var courses = Array<Course>()
  override func viewDidLoad() {
    super.viewDidLoad()
    self.courses = self.loadCourses()
  }
}

