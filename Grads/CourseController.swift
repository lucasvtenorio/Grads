//
//  CourseController.swift
//  Grads
//
//  Created by Lucas Tenório on 16/02/16.
//  Copyright © 2016 lvt. All rights reserved.
//

import Foundation



class CourseController: DataManager {
  enum Errors: ErrorType {
    case CourseClashesWithCourse(Course)
    case CourseIsNotSelected(Course)
    case CourseNotInAllCourses(Set<Course>)
  }

  private var internalAllCourses: Set<Course>? = nil
  private var internalSelectedCourses = Set<Course>()

  static let sharedController = CourseController()
  private init () {}

  var allCourses: Set<Course> {
    get {
      if let courses = self.internalAllCourses {
        return courses;
      }
      let result = self.loadCourses()
      self.internalAllCourses = Set<Course>(result)
      return Set<Course>(result)
    }
  }

  var selectedCourses: Set<Course> {
    get {
      return self.internalSelectedCourses
    }
  }

  var notSelectedCourses: Set<Course> {
    get {
      return self.allCourses.subtract(self.selectedCourses)
    }
  }

  var clashedCourses: Set<Course> {
    get {
      let array = self.notSelectedCourses.filter { (course) -> Bool in
        for selectedCourse in self.selectedCourses {
          if course.clashesWith(selectedCourse) {
            return true
          }
        }
        return false
      }
      return Set<Course>(array)
    }
  }

  var availableCourses: Set<Course> {
    get {
      return self.notSelectedCourses.subtract(self.clashedCourses)
    }
  }

  func selectCourse(course: Course) throws {
    if !self.allCourses.contains(course) {
      throw Errors.CourseNotInAllCourses(self.allCourses)
    }
    for oldCourse in self.internalSelectedCourses {
      if oldCourse.clashesWith(course) {
        throw Errors.CourseClashesWithCourse(oldCourse)
      }
    }
    self.internalSelectedCourses.insert(course)
  }

  func deselectCourse(course: Course) throws {
    if !self.internalSelectedCourses.contains(course) {
      throw Errors.CourseIsNotSelected(course)
    }

    self.internalSelectedCourses.remove(course)
  }
}
