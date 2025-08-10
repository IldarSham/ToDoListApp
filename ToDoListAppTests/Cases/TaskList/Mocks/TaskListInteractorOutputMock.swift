//
//  TaskListInteractorOutputMock.swift
//  ToDoListAppTests
//
//  Created by Ildar Shamsullin on 10.08.2025.
//

import Foundation
@testable import ToDoListApp

class TaskListInteractorOutputMock: TaskListInteractorOutputProtocol {
  var receivedResult: TaskListResult!
  
  func didFinishTaskOperation(result: TaskListResult) {
    receivedResult = result
  }
}
