//
//  MockStartInteractorInput.swift
//  ToDoListAppTests
//
//  Created by Ildar Shamsullin on 10.08.2025.
//

import Foundation
@testable import ToDoListApp

class MockStartInteractor: StartInteractorInputProtocol {
  var seedDatabaseIfNeededCalled = false
  
  func seedDatabaseIfNeeded() {
    seedDatabaseIfNeededCalled = true
  }
}
