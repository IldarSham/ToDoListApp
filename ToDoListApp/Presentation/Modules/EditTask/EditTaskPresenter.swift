//
//  EditTaskPresenter.swift
//  ToDoListApp
//
//  Created by Ildar Shamsullin on 07.08.2025.
//

import Foundation

class EditTaskPresenter: EditTaskPresenterProtocol {
  
  // MARK: - Dependencies
  
  var interactor: EditTaskInteractorInputProtocol?
  weak var delegate: EditTaskModuleDelegate?
  
  // MARK: - Computed Properties
  
  public var editingTask: Todo? {
    interactor?.editingTask
  }
  
  public var initialTitle: String {
    editingTask?.title ?? ""
  }
  
  public var initialDescription: String? {
    editingTask?.content
  }
  
  public var formattedDate: String {
    editingTask?.date.formattedAsString() ?? Date.now.formattedAsString()
  }
  
  // MARK: - Public Methods
  
  func saveTask(title: String, description: String) {
    interactor?.persistTask(title: title, description: description)
  }
}

// MARK: - EditTaskInteractorOutputProtocol
extension EditTaskPresenter: EditTaskInteractorOutputProtocol {
  
  func didFinishEditingTask(result: EditTaskResult) {
    switch result {
    case .created(let task):
      delegate?.didCreateTask(task)
      
    case .updated(let task):
      delegate?.didUpdateTask(task)
      
    case .failure(let error):
      print(error)
    }
  }
}
