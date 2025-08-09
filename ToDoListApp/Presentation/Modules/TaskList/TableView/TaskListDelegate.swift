//
//  TaskListDelegate.swift
//  ToDoListApp
//
//  Created by Ildar Shamsullin on 09.08.2025.
//

import UIKit

final class TaskListDelegate: NSObject, UITableViewDelegate {
  
  // MARK: - Dependencies
  
  private let dataSource: TaskListDataSource
  private weak var presenter: TaskListPresenterProtocol?
  
  // MARK: - Initialization
  
  init(dataSource: TaskListDataSource, presenter: TaskListPresenterProtocol?) {
    self.dataSource = dataSource
    self.presenter = presenter
  }
  
  // MARK: - Context Menu
  
  func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
    guard let task = dataSource.item(at: indexPath) else { return nil }
    
    return UIContextMenuConfiguration(identifier: task.objectID as NSCopying, previewProvider: nil) { [weak self] _ in
      return self?.createContextMenu(for: task)
    }
  }
  
  func tableView(_ tableView: UITableView, previewForHighlightingContextMenuWithConfiguration configuration: UIContextMenuConfiguration) -> UITargetedPreview? {
    return createTargetedPreview(for: configuration, in: tableView, highlighted: true)
  }
  
  func tableView(_ tableView: UITableView, previewForDismissingContextMenuWithConfiguration configuration: UIContextMenuConfiguration) -> UITargetedPreview? {
    return createTargetedPreview(for: configuration, in: tableView, highlighted: false)
  }
  
  // MARK: - Context Menu Animations
  
  func tableView(_ tableView: UITableView, willDisplayContextMenu configuration: UIContextMenuConfiguration, animator: UIContextMenuInteractionAnimating?) {
    animateContextMenu(for: configuration, in: tableView, isOpening: true, animator: animator)
  }
  
  func tableView(_ tableView: UITableView, willEndContextMenuInteraction configuration: UIContextMenuConfiguration, animator: UIContextMenuInteractionAnimating?) {
    animateContextMenu(for: configuration, in: tableView, isOpening: false, animator: animator)
  }
}

// MARK: - Private Helpers
private extension TaskListDelegate {
  
  func createContextMenu(for task: Todo) -> UIMenu {
    let editAction = UIAction(title: "Редактировать", image: UIImage(systemName: "square.and.pencil")) { [weak self] _ in
      self?.presenter?.didSelectEditAction(for: task)
    }
    
    let shareAction = UIAction(title: "Поделиться", image: UIImage(systemName: "square.and.arrow.up")) { _ in }
    
    let deleteAction = UIAction(title: "Удалить", image: UIImage(systemName: "trash"), attributes: .destructive) { [weak self] _ in
      self?.presenter?.didSelectDeleteAction(for: task)
    }
    
    return UIMenu(children: [editAction, shareAction, deleteAction])
  }
  
  func getCell(for configuration: UIContextMenuConfiguration, in tableView: UITableView) -> TaskCell? {
    guard
      let task = dataSource.item(with: configuration.identifier),
      let indexPath = dataSource.indexPath(for: task)
    else { return nil }
    
    return tableView.cellForRow(at: indexPath) as? TaskCell
  }
  
  func createTargetedPreview(for config: UIContextMenuConfiguration, in tableView: UITableView, highlighted: Bool) -> UITargetedPreview? {
    guard let cell = getCell(for: config, in: tableView) else { return nil }
    
    let parameters = UIPreviewParameters()
    parameters.backgroundColor = highlighted ? .primaryDarkGrayColor : .clear
    
    return UITargetedPreview(view: cell, parameters: parameters)
  }
  
  func animateContextMenu(for config: UIContextMenuConfiguration, in tableView: UITableView, isOpening: Bool, animator: UIContextMenuInteractionAnimating?) {
    guard let cell = getCell(for: config, in: tableView) else { return }
    
    tableView.separatorStyle = isOpening ? .none : .singleLine
    
    animator?.addAnimations {
      cell.setCheckmarkHidden(isOpening)
    }
  }
}
