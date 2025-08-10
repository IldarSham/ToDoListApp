//
//  EditTaskInteractorOutputMock.swift
//  ToDoListAppTests
//
//  Created by Ildar Shamsullin on 10.08.2025.
//

import Foundation
@testable import ToDoListApp

class EditTaskInteractorOutputMock: EditTaskInteractorOutputProtocol {
  var receivedResult: EditTaskResult!
  
  func didFinishEditingTask(result: EditTaskResult) {
    receivedResult = result
  }
}
