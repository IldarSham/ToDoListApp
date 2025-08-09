//
//  StartContract.swift
//  ToDoListApp
//
//  Created by Ildar Shamsullin on 08.08.2025.
//

import Foundation

protocol StartPresenterProtocol {
  func viewDidLoad()
}

protocol StartInteractorInputProtocol {
  func seedDatabaseIfNeeded()
}

protocol StartInteractorOutputProtocol {
  func didFinishSeedingDatabase(result: SeedingResult)
}

protocol StartRouterProtocol {
  func startMainFlow()
}
