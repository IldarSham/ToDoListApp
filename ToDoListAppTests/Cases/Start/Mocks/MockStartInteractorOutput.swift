//
//  MockStartInteractorOutput.swift
//  ToDoListAppTests
//
//  Created by Ildar Shamsullin on 10.08.2025.
//

import Foundation
@testable import ToDoListApp

class MockStartInteractorOutput: StartInteractorOutputProtocol {
  var didFinishSeedingCalled = false
  var receivedResult: SeedingResult?
  
  func didFinishSeedingDatabase(result: SeedingResult) {
    didFinishSeedingCalled = true
    receivedResult = result
  }
}
