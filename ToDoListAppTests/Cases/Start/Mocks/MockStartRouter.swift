//
//  MockStartRouter.swift
//  ToDoListAppTests
//
//  Created by Ildar Shamsullin on 10.08.2025.
//

import Foundation
@testable import ToDoListApp

class MockStartRouter: StartRouterProtocol {
  var startMainFlowCalled = false
  
  func startMainFlow() {
    startMainFlowCalled = true
  }
}
