//
//  StartInteractor.swift
//  ToDoListApp
//
//  Created by Ildar Shamsullin on 08.08.2025.
//

import Foundation

class StartInteractor: StartInteractorInputProtocol {
  
  // MARK: - Properties
  
  public var presenter: StartInteractorOutputProtocol?
  
  // MARK: - Dependencies
  
  private let storage: SeedDataStatusStorage
  private let apiManager: RemoteAPIManagerProtocol
  private let repository: any RepositoryProtocol<Todo>
  
  // MARK: - Initialization
  
  init(storage: SeedDataStatusStorage,
       apiManager: RemoteAPIManagerProtocol,
       repository: any RepositoryProtocol<Todo>) {
    self.storage = storage
    self.apiManager = apiManager
    self.repository = repository
  }

  // MARK: - Public Methods
  
  public func seedDatabaseIfNeeded() {
    guard !storage.isSeedDataCompleted else {
      presenter?.didFinishSeedingDatabase(result: .alreadySeeded)
      return
    }

    apiManager.callAPI(with: TodosRequest()) { [weak self] (result: Result<Page<TodoPayload>, Error>) in
      guard let self = self else { return }

      switch result {
      case .success(let response):
        self.saveTodos(response.todos)
      case .failure(let error):
        self.presenter?.didFinishSeedingDatabase(result: .failure(error))
      }
    }
  }

  // MARK: - Private Methods
  
  private func saveTodos(_ todos: [TodoPayload]) {
    repository.createBatch(items: todos) { todo, payload in
      todo.title = payload.todo
      todo.date = .now
      todo.isCompleted = payload.completed
    } completion: { [weak self] result in
      guard let self = self else { return }

      switch result {
      case .success:
        self.storage.isSeedDataCompleted = true
        self.presenter?.didFinishSeedingDatabase(result: .success)
      case .failure(let error):
        self.presenter?.didFinishSeedingDatabase(result: .failure(error))
      }
    }
  }
}
