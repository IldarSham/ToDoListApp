//
//  TaskListResult+Equatable.swift
//  ToDoListApp
//
//  Created by Ildar Shamsullin on 10.08.2025.
//

import Foundation

extension TaskListResult: Equatable {
  public static func == (lhs: TaskListResult, rhs: TaskListResult) -> Bool {
    switch (lhs, rhs) {
    case let (.fetched(lhsTodos), .fetched(rhsTodos)):
      return lhsTodos == rhsTodos
    case let (.toggled(lhsTodo), .toggled(rhsTodo)),
      let (.deleted(lhsTodo), .deleted(rhsTodo)):
      return lhsTodo == rhsTodo
    case let (.failure(lhsError), .failure(rhsError)):
      return lhsError.localizedDescription == rhsError.localizedDescription
    default:
      return false
    }
  }
}
