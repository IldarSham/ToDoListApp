//
//  TaskListPresenter.swift
//  ToDoListApp
//
//  Created by Ildar Shamsullin on 04.08.2025.
//

import Foundation

class TaskListPresenter: TaskListPresenterProtocol {
  
  // MARK: - Dependencies
  
  public weak var view: TaskListViewProtocol?
  public var interactor: TaskListInteractorInputProtocol?
  public var router: TaskListRouterProtocol?
  
  // MARK: - State
  
  private var todos: [Todo] = [] {
    didSet { publishChanges() }
  }
  
  private var searchText: String = "" {
    didSet { publishChanges() }
  }
  
  private var filteredTasks: [Todo] {
    todos.filter {
      searchText.isEmpty ||
      $0.title.localizedCaseInsensitiveContains(searchText)
    }
  }
    
  // MARK: - Public Methods
  
  public func viewDidLoad() {
    interactor?.fetchTaskList()
  }
  
  func createViewModel(for todo: Todo) -> TaskCellViewModel {
    return TaskCellViewModel(
      title: todo.title,
      description: todo.content,
      date: todo.date.formattedAsString(),
      isCompleted: todo.isCompleted
    )
  }
  
  // MARK: - User Actions

  public func didTapCheckmarkButton(for todo: Todo) {
    interactor?.toggleCompletionStatus(for: todo)
  }
  
  public func didSelectEditAction(for todo: Todo) {
    router?.showEditTask(todo: todo)
  }
  
  public func didSelectDeleteAction(for todo: Todo) {
    interactor?.deleteTask(todo)
  }
  
  public func didTapNewTaskButton() {
    router?.showEditTask(todo: nil)
  }
  
  public func filterTasks(with searchText: String) {
    self.searchText = searchText
  }
  
  // MARK: - Private Helpers
  
  private func publishChanges() {
    view?.display(tasks: filteredTasks)
    view?.displayTaskCount(todos.count)
  }
}

// MARK: - TaskListInteractorOutputProtocol
extension TaskListPresenter: TaskListInteractorOutputProtocol {
  
  func didFinishTaskOperation(result: TaskListResult) {
    switch result {
    case .fetched(let todos):
      self.todos = todos
      
    case .toggled(let todo):
      view?.reload(tasks: [todo])
      
    case .deleted(let todo):
      todos.removeAll { $0 == todo }
      
    case .failure(let error):
      print(error)
    }
  }
}

// MARK: - EditTaskModuleDelegate
extension TaskListPresenter: EditTaskModuleDelegate {
  
  func didCreateTask(_ task: Todo) {
    todos.insert(task, at: 0)
  }
  
  func didUpdateTask(_ task: Todo) {
    view?.reload(tasks: [task])
  }
}
