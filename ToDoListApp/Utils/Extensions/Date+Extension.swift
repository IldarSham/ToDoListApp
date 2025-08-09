//
//  Date+Extension.swift
//  ToDoListApp
//
//  Created by Ildar Shamsullin on 08.08.2025.
//

import Foundation

public extension Date {
  func formattedAsString() -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = "dd/MM/yyyy"
    return formatter.string(from: self)
  }
}
