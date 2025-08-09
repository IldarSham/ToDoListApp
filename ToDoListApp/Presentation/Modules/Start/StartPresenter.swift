//
//  StartPresenter.swift
//  ToDoListApp
//
//  Created by Ildar Shamsullin on 08.08.2025.
//

import Foundation

class StartPresenter: StartPresenterProtocol {
  
  // MARK: - Properties
  
  public var interactor: StartInteractorInputProtocol?
  public var router: StartRouterProtocol?
  
  // MARK: - Methods
  
  public func viewDidLoad() {
    interactor?.seedDatabaseIfNeeded()
  }
}

// MARK: - StartInteractorOutputProtocol
extension StartPresenter: StartInteractorOutputProtocol {
  
  func didFinishSeedingDatabase(result: SeedingResult) {
    router?.startMainFlow()
  }
}
