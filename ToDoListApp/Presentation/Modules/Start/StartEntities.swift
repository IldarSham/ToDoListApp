//
//  StartEntities.swift
//  ToDoListApp
//
//  Created by Ildar Shamsullin on 10.08.2025.
//

import Foundation

public enum SeedingResult {
  case success
  case failure(Error)
  case alreadySeeded
}

extension SeedingResult: Equatable {
  public static func == (lhs: SeedingResult, rhs: SeedingResult) -> Bool {
    switch (lhs, rhs) {
    case (.success, .success):
      return true
    case (.alreadySeeded, .alreadySeeded):
      return true
    case let (.failure(lhsError), .failure(rhsError)):
      return lhsError.localizedDescription == rhsError.localizedDescription
    default:
      return false
    }
  }
}
