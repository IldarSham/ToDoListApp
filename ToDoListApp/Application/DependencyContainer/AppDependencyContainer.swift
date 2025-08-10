//
//  AppDependencyContainer.swift
//  ToDoListApp
//
//  Created by Ildar Shamsullin on 07.08.2025.
//

import UIKit

final class AppDependencyContainer: StartViewControllerFactory,
                                    TaskListViewControllerFactory,
                                    EditTaskViewControllerFactory {
  // MARK: - Properties
  
  // Long-lived dependencies
  private let apiManager: RemoteAPIManagerProtocol
  private let coreDataStack: CoreDataStack
  private let todosRepository: any RepositoryProtocol<Todo>
  private let taskListPresenter: TaskListPresenter
    
  // MARK: - Initialization
  
  init() {
    func makeUrlSessionManager() -> URLSessionManagerProtocol {
      return URLSessionManager()
    }
    func makeRemoteAPIManager() -> RemoteAPIManagerProtocol {
      let urlSessionManager = makeUrlSessionManager()
      return RemoteAPIManager(urlSessionManager: urlSessionManager)
    }
    func makeCoreDataStack() -> CoreDataStack {
      return CoreDataStack()
    }
    func makeTodosRepository(stack: CoreDataStack) -> any RepositoryProtocol<Todo> {
      return CoreDataRepository(stack: stack)
    }
    func makeTaskListPresenter() -> TaskListPresenter {
      return TaskListPresenter()
    }
    self.apiManager = makeRemoteAPIManager()
    self.coreDataStack = makeCoreDataStack()
    self.todosRepository = makeTodosRepository(stack: coreDataStack)
    self.taskListPresenter = makeTaskListPresenter()
  }
  
  // MARK: - StartViewControllerFactory
  
  public func makeStartViewController(router: StartRouterProtocol) -> StartViewController {
    let view = StartViewController()
    let presenter = StartPresenter()
    let interactor = makeStartInteractor()

    view.presenter = presenter
    presenter.interactor = interactor
    presenter.router = router
    interactor.presenter = presenter
    
    return view
  }
  
  public func makeStartInteractor() -> StartInteractor {
    let userDefaults = UserDefaultsLayer()
    return StartInteractor(storage: userDefaults,
                           apiManager: apiManager,
                           repository: todosRepository)
  }
  
  // MARK: - TaskListViewControllerFactory
  
  public func makeTaskListViewController(using navigationController: UINavigationController) -> TaskListViewController {
    let view = TaskListViewController()
    let presenter = taskListPresenter
    let interactor = makeTaskListInteractor(repository: todosRepository)
    let router = makeTaskListRouter(using: navigationController)
    
    view.presenter = presenter
    presenter.view = view
    presenter.interactor = interactor
    presenter.router = router
    interactor.presenter = presenter
    
    return view
  }
  
  func makeTaskListInteractor(repository: any RepositoryProtocol<Todo>) -> TaskListInteractor {
    return TaskListInteractor(repository: repository)
  }
  
  public func makeTaskListRouter(using navigationController: UINavigationController) -> TaskListRouterProtocol {
    return TaskListRouter(navigationController: navigationController,
                          editTaskViewControllerFactory: self)
  }
  
  // MARK: - EditTaskViewControllerFactory
  
  public func makeEditTaskViewController(editingTask: Todo?) -> EditTaskViewController {
    let view = EditTaskViewController()
    let presenter = EditTaskPresenter()
    let interactor = makeEditTaskInteractor(editingTask: editingTask)
    
    view.presenter = presenter
    presenter.view = view
    presenter.interactor = interactor
    presenter.delegate = taskListPresenter
    interactor.presenter = presenter
    
    return view
  }
  
  public func makeEditTaskInteractor(editingTask: Todo?) -> EditTaskInteractor {
    return EditTaskInteractor(editingTask: editingTask,
                              repository: todosRepository)
  }
}
