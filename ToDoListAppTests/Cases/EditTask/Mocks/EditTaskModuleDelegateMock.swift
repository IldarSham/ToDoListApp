//
//  EditTaskModuleDelegateMock.swift
//  ToDoListAppTests
//
//  Created by Ildar Shamsullin on 10.08.2025.
//

import Foundation
@testable import ToDoListApp

class EditTaskModuleDelegateMock: EditTaskModuleDelegate {
  var createdTask: Todo!
  var updatedTask: Todo!
  
  func didCreateTask(_ task: Todo) {
    createdTask = task
  }
  
  func didUpdateTask(_ task: Todo) {
    updatedTask = task
  }
}
