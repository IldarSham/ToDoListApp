//
//  EditTaskEntities.swift
//  ToDoListApp
//
//  Created by Ildar Shamsullin on 10.08.2025.
//

import Foundation

public enum EditTaskResult: Equatable {
  case created(Todo)
  case updated(Todo)
  case failure(Error)
}

extension EditTaskResult {
  public static func == (lhs: EditTaskResult, rhs: EditTaskResult) -> Bool {
    switch (lhs, rhs) {
    case let (.created(lhsTodo), .created(rhsTodo)):
      return lhsTodo == rhsTodo
    case let (.updated(lhsTodo), .updated(rhsTodo)):
      return lhsTodo == rhsTodo
    case let (.failure(lhsError), .failure(rhsError)):
      return lhsError.localizedDescription == rhsError.localizedDescription
    default:
      return false
    }
  }
}
