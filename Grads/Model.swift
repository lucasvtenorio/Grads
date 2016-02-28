//
//  Model.swift
//  Grads
//
//  Created by Lucas Tenório on 14/02/16.
//  Copyright © 2016 lvt. All rights reserved.
//

import Foundation

typealias RawCourse = Dictionary<String, String>
enum DayOfWeek: String, Comparable {
  case Monday = "seg"
  case Tuesday = "ter"
  case Wednesday = "qua"
  case Thursday = "qui"
  case Friday = "sex"
  case Saturday = "sab"
  case Sunday = "dom"
  func order() -> Int {
    switch self {
    case .Monday:
      return 1
    case .Tuesday:
      return 2
    case .Wednesday:
      return 3
    case .Thursday:
      return 4
    case .Friday:
      return 5
    case .Saturday:
      return 6
    case .Sunday:
      return 7
    }
  }
}

func < (lhs: DayOfWeek, rhs: DayOfWeek) -> Bool {
  return lhs.order() < rhs.order()
}

struct TimeOfDay: Hashable, Comparable {
  let hours: Int
  let minutes: Int
  var hashValue: Int {
    get {
      return self.hours ^ self.minutes
    }
  }
  init? (hours: Int = 0, minutes: Int = 0) {
    guard hours >= 0 && hours <= 23 &&
          minutes >= 0 && minutes <= 59 else { return nil }

    self.hours = hours
    self.minutes = minutes
  }
}

func == (lhs: TimeOfDay, rhs: TimeOfDay) -> Bool {
  return lhs.hours == rhs.hours && lhs.minutes == rhs.minutes
}

func < (lhs: TimeOfDay, rhs: TimeOfDay) -> Bool {
  if lhs.hours < rhs.hours {
    return true
  } else if lhs.hours > rhs.hours {
    return false
  } else  {
    return lhs.minutes < rhs.minutes
  }
}

struct ClassTime: Hashable, Comparable{
  let day: DayOfWeek
  let startTime: TimeOfDay
  let finishTime: TimeOfDay
  var hashValue: Int {
    get {
      return self.day.rawValue.hashValue ^ self.startTime.hashValue ^ self.finishTime.hashValue
    }
  }

  init?(day: DayOfWeek, startTime: TimeOfDay, finishTime: TimeOfDay) {
    if startTime > finishTime { return nil }
    self.day = day
    self.startTime = startTime
    self.finishTime = finishTime
  }

  func clashesWith(otherClass: ClassTime) -> Bool {
    if otherClass.day == self.day {
      if otherClass.startTime >= self.startTime && otherClass.startTime < self.finishTime {
        return true
      }
      if otherClass.finishTime > self.startTime && otherClass.finishTime <= self.finishTime {
        return true
      }
    }
    return false
  }
}

func == (lhs:ClassTime, rhs: ClassTime) -> Bool {
  return lhs.day == rhs.day && lhs.startTime == rhs.startTime && lhs.finishTime == rhs.finishTime
}

func < (lhs: ClassTime, rhs: ClassTime) -> Bool {
  if lhs.day != rhs.day {
    return lhs.day < rhs.day
  }
  if lhs.startTime != rhs.startTime {
    return lhs.startTime < rhs.startTime
  }
  if lhs.finishTime != rhs.finishTime {
    return lhs.finishTime < rhs.finishTime
  }
  // Everything is equal, return false
  return false
}

struct Course: Hashable {
  let code: String
  let name: String
  let teacher: String
  let room: String?
  let times: [ClassTime]
  var hashValue: Int {
    get {
      return name.hashValue ^ times.count
    }
  }

  func clashesWith(otherCourse: Course) -> Bool {
    for myTime in self.times {
      for theirTime in otherCourse.times {
        if myTime.clashesWith(theirTime) {
          return true
        }
      }
    }
    return false
  }
}

func == (lhs: Course, rhs: Course) -> Bool {
  return lhs.name == rhs.name && lhs.times == rhs.times
}
