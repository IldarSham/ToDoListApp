//
//  TaskListDataSource.swift
//  ToDoListApp
//
//  Created by Ildar Shamsullin on 09.08.2025.
//

import UIKit
import CoreData

final class TaskListDataSource: UITableViewDiffableDataSource<TaskList.Section, Todo> {
  
  // MARK: - Dependencies
  
  private weak var presenter: TaskListPresenterProtocol?
  
  // MARK: - Initialization
  
  public init(tableView: UITableView, presenter: TaskListPresenterProtocol?) {
    self.presenter = presenter
    
    super.init(tableView: tableView) { tableView, indexPath, todo -> UITableViewCell? in
      guard
        let presenter = presenter,
        let cell = tableView.dequeueReusableCell(withIdentifier: TaskCell.reuseIdentifier, for: indexPath) as? TaskCell
      else {
        return UITableViewCell()
      }
      
      let viewModel = presenter.createViewModel(for: todo)
      
      cell.configure(with: viewModel) {
        presenter.didTapCheckmarkButton(for: todo)
      }
      
      cell.selectionStyle = .none
      return cell
    }
  }
  
  // MARK: - Public Methods
  
  public func applySnapshot(tasks: [Todo], animatingDifferences: Bool) {
    var snapshot = NSDiffableDataSourceSnapshot<TaskList.Section, Todo>()
    snapshot.appendSections([.main])
    snapshot.appendItems(tasks, toSection: .main)
    apply(snapshot, animatingDifferences: animatingDifferences)
  }
  
  public func reloadItems(_ items: [Todo]) {
    var currentSnapshot = snapshot()
    currentSnapshot.reloadItems(items)
    apply(currentSnapshot, animatingDifferences: true)
  }
  
  public func item(at indexPath: IndexPath) -> Todo? {
    return itemIdentifier(for: indexPath)
  }
  
  func item(with identifier: Any) -> Todo? {
    guard let objectID = identifier as? NSManagedObjectID else { return nil }
    return snapshot().itemIdentifiers.first { $0.objectID == objectID }
  }
}

enum TaskList {
  enum Section {
    case main
  }
}
