//
//  EditTaskInteractorInputMock.swift
//  ToDoListAppTests
//
//  Created by Ildar Shamsullin on 10.08.2025.
//

import Foundation
@testable import ToDoListApp

class EditTaskInteractorInputMock: EditTaskInteractorInputProtocol {
  var editingTask: Todo?
  
  var persistTaskCalled = false
  var receivedTitle: String!
  var receivedDescription: String!
  
  func persistTask(title: String, description: String) {
    persistTaskCalled = true
    receivedTitle = title
    receivedDescription = description
  }
}
