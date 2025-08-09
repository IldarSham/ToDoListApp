//
//  StartRouter.swift
//  ToDoListApp
//
//  Created by Ildar Shamsullin on 08.08.2025.
//

import UIKit

class StartRouter {
  
  // MARK: - Properties
  let navigationController: UINavigationController
  
  // Factories
  let taskListViewControllerFactory: TaskListViewControllerFactory

  // MARK: - Initialization
  init(navigationController: UINavigationController,
       taskListViewControllerFactory: TaskListViewControllerFactory) {
    self.navigationController = navigationController
    self.taskListViewControllerFactory = taskListViewControllerFactory
  }
}

extension StartRouter: StartRouterProtocol {
  
  func startMainFlow() {
    let viewController = taskListViewControllerFactory.makeTaskListViewController(using: navigationController)
    navigationController.setViewControllers([viewController], animated: false)
  }
}
