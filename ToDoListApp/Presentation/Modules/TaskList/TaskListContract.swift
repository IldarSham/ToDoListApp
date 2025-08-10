//
//  TaskListContract.swift
//  ToDoListApp
//
//  Created by Ildar Shamsullin on 04.08.2025.
//

import Foundation

protocol TaskListViewProtocol: Alertable, AnyObject {
  func display(tasks: [Todo])
  func displayTaskCount(_ count: Int)
  func reload(tasks: [Todo])
}

protocol TaskListPresenterProtocol: AnyObject {
  func viewDidLoad()
  func createViewModel(for todo: Todo) -> TaskCellViewModel
  func didTapCheckmarkButton(for todo: Todo)
  func didSelectEditAction(for todo: Todo)
  func didSelectDeleteAction(for todo: Todo)
  func didTapNewTaskButton()
  func filterTasks(with searchText: String)
}

protocol TaskListInteractorInputProtocol: AnyObject {
  func fetchTaskList()
  func toggleCompletionStatus(for task: Todo)
  func deleteTask(_ task: Todo)
}

protocol TaskListInteractorOutputProtocol: AnyObject {
  func didFinishTaskOperation(result: TaskListResult)
}

protocol TaskListRouterProtocol: AnyObject {
  func showEditTask(todo: Todo?)
}
