//
//  TaskListInteractor.swift
//  ToDoListApp
//
//  Created by Ildar Shamsullin on 04.08.2025.
//

import Foundation

class TaskListInteractor: TaskListInteractorInputProtocol {
  
  // MARK: - Dependencies
  
  public weak var presenter: TaskListInteractorOutputProtocol?
  private let repository: any RepositoryProtocol<Todo>
  
  // MARK: - Initialization
  
  public init(repository: any RepositoryProtocol<Todo>) {
    self.repository = repository
  }
  
  // MARK: - Public Methods
  
  public func fetchTaskList() {
    let sortDescriptors = [NSSortDescriptor(key: #keyPath(Todo.date), ascending: false)]
    
    repository.fetch(
      sort: sortDescriptors
    ) { [weak self] result in
      self?.handleResult(result) { .fetched($0) }
    }
  }
  
  public func toggleCompletionStatus(for task: Todo) {
    repository.update(object: task) { updated in
      updated.isCompleted.toggle()
    } completion: { [weak self] result in
      self?.handleResult(result) { _ in .toggled(task) }
    }
  }
  
  public func deleteTask(_ task: Todo) {
    repository.delete(object: task) { [weak self] result in
      self?.handleResult(result) { _ in .deleted(task) }
    }
  }
  
  // MARK: - Private Helpers
  
  private func handleResult<Success>(_ result: Result<Success, Error>,
                                     successCase: (Success) -> TaskListResult) {
    switch result {
    case .success(let value):
      presenter?.didFinishTaskOperation(result: successCase(value))
    case .failure(let error):
      presenter?.didFinishTaskOperation(result: .failure(error))
    }
  }
}
