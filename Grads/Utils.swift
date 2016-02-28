//
//  Utils.swift
//  Grads
//
//  Created by Lucas Tenório on 16/02/16.
//  Copyright © 2016 lvt. All rights reserved.
//

import Foundation

extension Array {
  mutating func remove <U: Equatable> (object: U) {
    for i in (self.count - 1).stride(through: 0, by: -1) {
      if let element = self[i] as? U {
        if element == object {
          self.removeAtIndex(i)
          return
        }
      }
    }
  }
}