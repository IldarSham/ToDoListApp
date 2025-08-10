//
//  EditTaskContract.swift
//  ToDoListApp
//
//  Created by Ildar Shamsullin on 07.08.2025.
//

import Foundation

protocol EditTaskViewProtocol: Alertable, AnyObject {}

protocol EditTaskPresenterProtocol {
  var initialTitle: String { get }
  var initialDescription: String? { get }
  var formattedDate: String { get }
  func saveTask(title: String, description: String)
}

protocol EditTaskInteractorInputProtocol {
  var editingTask: Todo? { get }
  func persistTask(title: String, description: String)
}

protocol EditTaskInteractorOutputProtocol: AnyObject {
  func didFinishEditingTask(result: EditTaskResult)
}

protocol EditTaskModuleDelegate: AnyObject {
  func didCreateTask(_ task: Todo)
  func didUpdateTask(_ task: Todo)
}
