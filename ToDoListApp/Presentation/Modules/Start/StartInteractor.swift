//
//  StartInteractor.swift
//  ToDoListApp
//
//  Created by Ildar Shamsullin on 08.08.2025.
//

import Foundation

public enum SeedingResult {
  case success
  case failure(Error)
  case alreadySeeded
}

class StartInteractor: StartInteractorInputProtocol {
  
  // MARK: - Properties
  
  var presenter: StartInteractorOutputProtocol?
  
  // MARK: - Dependencies
  
  private let seedDataStatusStorage: SeedDataStatusStorage
  private let apiManager: RemoteAPIManagerProtocol
  private let todosRepository: CoreDataRepository<Todo>
  
  // MARK: - Initialization
  
  init(seedDataStatusStorage: SeedDataStatusStorage,
       apiManager: RemoteAPIManagerProtocol,
       todosRepository: CoreDataRepository<Todo>) {
    self.seedDataStatusStorage = seedDataStatusStorage
    self.apiManager = apiManager
    self.todosRepository = todosRepository
  }

  // MARK: - Public Methods
  
  public func seedDatabaseIfNeeded() {
    guard !seedDataStatusStorage.isSeedDataCompleted else {
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
    todosRepository.createBatch(items: todos) { todo, payload in
      todo.title = payload.todo
      todo.date = .now
      todo.isCompleted = payload.completed
    } completion: { [weak self] result in
      guard let self = self else { return }

      switch result {
      case .success:
        self.seedDataStatusStorage.isSeedDataCompleted = true
        self.presenter?.didFinishSeedingDatabase(result: .success)
      case .failure(let error):
        self.presenter?.didFinishSeedingDatabase(result: .failure(error))
      }
    }
  }
}
