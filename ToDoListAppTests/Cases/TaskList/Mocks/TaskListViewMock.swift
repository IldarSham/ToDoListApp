//
//  TaskListViewMock.swift
//  ToDoListAppTests
//
//  Created by Ildar Shamsullin on 10.08.2025.
//

import Foundation
@testable import ToDoListApp

class TaskListViewMock: TaskListViewProtocol {
  var displayedTasks: [Todo]!
  var displayedTaskCount: Int!
  var reloadedTasks: [Todo]!
  
  func display(tasks: [Todo]) {
    displayedTasks = tasks
  }
  
  func displayTaskCount(_ count: Int) {
    displayedTaskCount = count
  }
  
  func reload(tasks: [Todo]) {
    reloadedTasks = tasks
  }
}
