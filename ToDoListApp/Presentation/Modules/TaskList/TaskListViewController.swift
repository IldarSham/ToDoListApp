//
//  TaskListViewController.swift
//  ToDoListApp
//
//  Created by Ildar Shamsullin on 04.08.2025.
//

import UIKit

class TaskListViewController: UIViewController {
  
  // MARK: - Properties
  
  var tasks = [
    TaskCellModel(title: "Задача 1", description: "Описание 1", date: "02/10/24", isCompleted: true),
    TaskCellModel(title: "Задача 2", description: "Описание 2", date: "02/10/24", isCompleted: false),
    TaskCellModel(title: "Задача 3", description: "Описание 3", date: "02/10/24", isCompleted: false)
  ]

  // MARK: - UI Elements
  
  private lazy var tableView: UITableView = {
    let tableView = UITableView()
    tableView.backgroundColor = .clear
    tableView.separatorColor = .gray
    tableView.separatorInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
    tableView.tableHeaderView = UIView()
    tableView.delegate = self
    tableView.dataSource = self
    tableView.register(TaskCell.self, forCellReuseIdentifier: TaskCell.reuseIdentifier)
    return tableView
  }()
  
  private let bottomBarView = BottomBarView()
  
  // MARK: - Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupAppearance()
    constructHierarchy()
    activateConstraints()
    setupNavigationItem()
    setupNavigationBar()
    configureNavigationBarAppearance()
    setupSearchController()
    configureBottomBar()
  }
  
  // MARK: - Private Methods
  
  private func setupNavigationItem() {
    navigationItem.title = "Задачи"
    navigationItem.hidesSearchBarWhenScrolling = false
  }
  
  private func setupNavigationBar() {
    navigationController?.navigationBar.prefersLargeTitles = true
  }
  
  private func configureNavigationBarAppearance() {
    let appearance = UINavigationBarAppearance()
    appearance.configureWithOpaqueBackground()
    appearance.backgroundColor = .black
    
    appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
    appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
    
    navigationController?.navigationBar.standardAppearance = appearance
    navigationController?.navigationBar.scrollEdgeAppearance = appearance
    navigationController?.navigationBar.compactAppearance = appearance
  }
  
  private func setupSearchController() {
    let searchController = UISearchController(searchResultsController: nil)
    searchController.searchResultsUpdater = self
    searchController.obscuresBackgroundDuringPresentation = false
    searchController.searchBar.searchTextField.backgroundColor = .primaryDarkGrayColor
    searchController.searchBar.searchTextField.attributedPlaceholder = NSAttributedString(
      string: "Search",
      attributes: [
        .foregroundColor: UIColor.primaryGrayColor,
        .font: UIFont.systemFont(ofSize: 19),
      ]
    )
    searchController.searchBar.searchTextField.leftView?.tintColor = UIColor.primaryGrayColor
    
    let micBase = UIImage(systemName: "mic.fill")!
    let micColored = micBase.withTintColor(.primaryGrayColor, renderingMode: .alwaysOriginal)

    searchController.searchBar.setImage(micColored, for: .bookmark, state: .normal)
    searchController.searchBar.showsBookmarkButton = true
    
    navigationItem.searchController = searchController
  }
  
  private func configureBottomBar() {
    bottomBarView.configure(taskCount: 7)
  }
  
  // MARK: - Helpers
  
  private func createTargetedPreview(for configuration: UIContextMenuConfiguration, in tableView: UITableView, highlighted: Bool) -> UITargetedPreview? {
    guard let cell = getTaskCell(for: configuration, in: tableView) else { return nil }
    
    let parameters = UIPreviewParameters()
    parameters.backgroundColor = highlighted ? .primaryDarkGrayColor : .clear
    
    return UITargetedPreview(view: cell, parameters: parameters)
  }
  
  private func animateCheckmark(for configuration: UIContextMenuConfiguration, in tableView: UITableView, hidden: Bool, animator: UIContextMenuInteractionAnimating?) {
    guard let cell = getTaskCell(for: configuration, in: tableView) else { return }
    
    animator?.addAnimations {
      cell.setCheckmarkHidden(hidden)
    }
  }
  
  private func getTaskCell(for configuration: UIContextMenuConfiguration, in tableView: UITableView) -> TaskCell? {
    guard let nsIndexPath = configuration.identifier as? NSIndexPath else { return nil }
    
    let indexPath = IndexPath(row: nsIndexPath.row, section: nsIndexPath.section)
    return tableView.cellForRow(at: indexPath) as? TaskCell
  }
}

// MARK: - View Setup
private extension TaskListViewController {
  
  func setupAppearance() {
    view.backgroundColor = .black
  }
  
  func constructHierarchy() {
    view.addSubview(tableView)
    view.addSubview(bottomBarView)
  }
}

// MARK: - Layout
private extension TaskListViewController {
  
  func activateConstraints() {
    activateConstraintsTableView()
    activateConstraintsBottomBarView()
  }
  
  func activateConstraintsTableView() {
    tableView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
      tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
    ])
  }
  
  func activateConstraintsBottomBarView() {
    bottomBarView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      bottomBarView.widthAnchor.constraint(equalTo: view.widthAnchor),
      bottomBarView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.1),
      bottomBarView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
    ])
  }
}

// MARK: - UISearchResultsUpdating
extension TaskListViewController: UISearchResultsUpdating {
  
  func updateSearchResults(for searchController: UISearchController) {
    
  }
}

// MARK: - UITableView DataSource & Delegate
extension TaskListViewController: UITableViewDataSource, UITableViewDelegate {
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return tasks.count
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: TaskCell.reuseIdentifier, for: indexPath) as! TaskCell
    cell.selectionStyle = .none
    cell.configure(with: tasks[indexPath.row])
    return cell
  }
  
  func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
    let configuration = UIContextMenuConfiguration(
      identifier: indexPath as NSIndexPath,
      previewProvider: nil
    ) { [weak self] _ -> UIMenu? in
      guard let self = self else { return nil }
      
      let editAction = UIAction(title: "Редактировать", image: UIImage(systemName: "square.and.pencil")) { action in
      }
      
      let shareAction = UIAction(title: "Поделиться", image: UIImage(systemName: "square.and.arrow.up")) { action in
      }
      
      let deleteAction = UIAction(title: "Удалить", image: UIImage(systemName: "trash"), attributes: .destructive) { action in
        self.tasks.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .automatic)
      }
      
      return UIMenu(children: [editAction, shareAction, deleteAction])
    }
    
    return configuration
  }
  
  func tableView(_ tableView: UITableView, previewForHighlightingContextMenuWithConfiguration configuration: UIContextMenuConfiguration) -> UITargetedPreview? {
    createTargetedPreview(for: configuration, in: tableView, highlighted: true)
  }
  
  func tableView(_ tableView: UITableView, previewForDismissingContextMenuWithConfiguration configuration: UIContextMenuConfiguration) -> UITargetedPreview? {
    createTargetedPreview(for: configuration, in: tableView, highlighted: false)
  }
  
  func tableView(_ tableView: UITableView, willDisplayContextMenu configuration: UIContextMenuConfiguration, animator: UIContextMenuInteractionAnimating?) {
    animateCheckmark(for: configuration, in: tableView, hidden: true, animator: animator)
  }
  
  func tableView(_ tableView: UITableView, willEndContextMenuInteraction configuration: UIContextMenuConfiguration, animator: UIContextMenuInteractionAnimating?) {
    animateCheckmark(for: configuration, in: tableView, hidden: false, animator: animator)
  }
}
