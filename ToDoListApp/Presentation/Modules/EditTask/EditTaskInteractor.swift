//
//  EditTaskInteractor.swift
//  ToDoListApp
//
//  Created by Ildar Shamsullin on 07.08.2025.
//

import Foundation

public enum EditTaskResult {
  case created(Todo)
  case updated(Todo)
  case failure(Error)
}

class EditTaskInteractor: EditTaskInteractorInputProtocol {
  
  // MARK: - Properties
  
  public weak var presenter: EditTaskInteractorOutputProtocol?
  
  // MARK: - Dependencies
  
  private(set) var editingTask: Todo?
  private let repository: CoreDataRepository<Todo>
  
  // MARK: - Initialization
  
  public init(editingTask: Todo?, repository: CoreDataRepository<Todo>) {
    self.editingTask = editingTask
    self.repository = repository
  }
  
  // MARK: - Public Methods
  
  public func persistTask(title: String, description: String) {
    guard !title.isEmpty else { return }
    
    editingTask != nil
      ? updateTask(title: title, description: description)
      : createTask(title: title, description: description)
  }
  
  // MARK: - Private Helpers
  
  private func updateTask(title: String, description: String) {
    guard let task = editingTask else { return }

    repository.update(object: task) { updated in
      updated.title = title
      updated.content = description
      updated.date = .now
    } completion: { [weak self] result in
      self?.handleResult(result) { .updated($0) }
    }
  }

  private func createTask(title: String, description: String) {
    repository.create { new in
      new.title = title
      new.content = description
      new.date = .now
      new.isCompleted = false
    } completion: { [weak self] result in
      self?.handleResult(result) { .created($0) }
    }
  }

  private func handleResult(_ result: Result<Todo, Error>,
                            successCase: (Todo) -> EditTaskResult) {
    switch result {
    case .success(let task):
      presenter?.didFinishEditingTask(result: successCase(task))
    case .failure(let error):
      presenter?.didFinishEditingTask(result: .failure(error))
    }
  }
}
