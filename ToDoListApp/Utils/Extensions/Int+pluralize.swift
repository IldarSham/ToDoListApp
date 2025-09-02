//
//  Int+pluralize.swift
//  ToDoListApp
//
//  Created by Ildar Shamsullin on 02.09.2025.
//

import Foundation

public extension Int {
  func pluralize(one: String, few: String, many: String) -> String {
    let mod100 = self % 100
    
    if (11...19).contains(mod100) {
      return many
    }
    
    let mod10 = self % 10
    switch mod10 {
    case 1:
      return one
    case 2, 3, 4:
      return few
    default:
      return many
    }
  }
}
