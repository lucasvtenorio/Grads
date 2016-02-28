//
//  DataLoader.swift
//  Grads
//
//  Created by Lucas Tenório on 14/02/16.
//  Copyright © 2016 lvt. All rights reserved.
//

import Foundation

protocol DataManager: DataLoader, DataParser {}
extension DataManager {
  func loadCourses() -> Array<Course>{
    var courses = Array<Course>()
    if let data = self.loadRawData() {
      for dictionary in data {
        if let course = self.parseCourse(dictionary) {
          courses.append(course)
        } else {
          print("failure to parse course \(dictionary)")
        }
      }
    } else {
      print("failure to load data!")
    }
    return courses
  }
}

protocol DataLoader {}
extension DataLoader {
  func loadRawData() -> Array<RawCourse>? {
    var myDict: NSArray?
    if let path = NSBundle.mainBundle().pathForResource("raw_cadeiras", ofType: "plist") {
      myDict = NSArray(contentsOfFile: path)
    }
    if let dict = myDict as? Array<RawCourse>{
      return dict
    } else {
      return nil
    }
  }
}

protocol DataParser {}
extension DataParser {
  func parseCourse(rawCourse: RawCourse) -> Course? {
    guard let
      rawName = rawCourse["course"],
      rawTeacher = rawCourse["teacher"],
      rawTime1 = rawCourse["time1"],
      rawTime2 = rawCourse["time2"],
      rawRoom = rawCourse["room"] else { return nil }

    var nameComponents = rawName.componentsSeparatedByString(" ")
    let code = nameComponents[0]
    nameComponents.removeFirst()
    let name = String(nameComponents.reduce("") { $0 + " " + $1 }.characters.dropFirst())
    var times = Array<ClassTime>()
    if let time1 = self.parseTime(rawTime1) {
      times.append(time1)
    }
    if let time2 = self.parseTime(rawTime2) {
      times.append(time2)
    }
    return Course(code: code, name: name, teacher: rawTeacher, room: rawRoom, times: times)
  }

  private func parseTime(rawTime: String) -> ClassTime? {
    if rawTime == "" { return nil }
    let components = rawTime.componentsSeparatedByString(" ")
    let dayName = String(components[0].characters.dropLast())
    guard let day = DayOfWeek(rawValue: dayName) else {
      print("Day (\(dayName)) does not work in raw time string: \(rawTime)!")
      return nil
    }
    let timeComponents = components[1].componentsSeparatedByString("-")
    guard let
      firstInt = Int(timeComponents[0]),
      secondInt = Int(timeComponents[1]),
      timeStart = TimeOfDay(hours: firstInt, minutes: 0),
      timeEnd = TimeOfDay(hours: secondInt, minutes: 0)else {
      print("Time (\(timeComponents)) does not work in raw time string: \(rawTime)!")
      return nil
    }
    if let result = ClassTime(day: day, startTime: timeStart, finishTime: timeEnd) {
      return result
    } else {
      print("Time (\(timeComponents)) could not be formed into ClassTime: \(rawTime)!")
      return nil
    }
  }
}
