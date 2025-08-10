//
//  TaskListRouterMock.swift
//  ToDoListAppTests
//
//  Created by Ildar Shamsullin on 10.08.2025.
//

import Foundation
@testable import ToDoListApp

class TaskListRouterMock: TaskListRouterProtocol {
  var shownTodoForEdit: Todo?
  var showEditTaskCalled = false
  
  var wasCalledForNewTask: Bool {
    showEditTaskCalled && shownTodoForEdit == nil
  }
  
  func showEditTask(todo: Todo?) {
    showEditTaskCalled = true
    shownTodoForEdit = todo
  }
}
