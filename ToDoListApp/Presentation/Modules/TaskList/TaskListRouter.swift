//
//  TaskListRouter.swift
//  ToDoListApp
//
//  Created by Ildar Shamsullin on 04.08.2025.
//

import UIKit

class TaskListRouter {
  
  // MARK: - Properties
  let navigationController: UINavigationController
  
  // Factories
  let editTaskViewControllerFactory: EditTaskViewControllerFactory

  // MARK: - Initialization
  init(navigationController: UINavigationController,
       editTaskViewControllerFactory: EditTaskViewControllerFactory) {
    self.navigationController = navigationController
    self.editTaskViewControllerFactory = editTaskViewControllerFactory
  }
}
 
// MARK: - TaskListRouterProtocol
extension TaskListRouter: TaskListRouterProtocol {
  
  func showEditTask(todo: Todo?) {
    let viewController = editTaskViewControllerFactory.makeEditTaskViewController(editingTask: todo)
    navigationController.pushViewController(viewController, animated: true)
  }
}
