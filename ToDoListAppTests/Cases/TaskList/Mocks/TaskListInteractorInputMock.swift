//
//  TaskListInteractorInputMock.swift
//  ToDoListAppTests
//
//  Created by Ildar Shamsullin on 10.08.2025.
//

import Foundation
@testable import ToDoListApp

class TaskListInteractorInputMock: TaskListInteractorInputProtocol {
  var fetchTaskListCalled = false
  var toggledTodo: Todo?
  var deletedTodo: Todo?
  
  func fetchTaskList() {
    fetchTaskListCalled = true
  }
  
  func toggleCompletionStatus(for todo: Todo) {
    toggledTodo = todo
  }
  
  func deleteTask(_ todo: Todo) {
    deletedTodo = todo
  }
}
