//
//  TaskListViewController.swift
//  ToDoListApp
//
//  Created by Ildar Shamsullin on 04.08.2025.
//

import UIKit
import CoreData

class TaskListViewController: UIViewController {
  
  // MARK: - Types
  
  private enum Constants {
    static let navigationTitle = "Задачи"
    static let searchPlaceholder = "Search"
  }
  
  // MARK: - Dependencies
  
  public var presenter: TaskListPresenterProtocol?
  
  // MARK: - Private Properties
  
  private var dataSource: TaskListDataSource!
  private var delegate: TaskListDelegate!
  
  // MARK: - UI Elements
  
  private lazy var tableView = makeTableView()
  private lazy var searchController = makeSearchController()
  private let bottomBarView = BottomBarView()
  
  // MARK: - Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupAppearance()
    constructHierarchy()
    activateConstraints()
    setupNavigationItem()
    setupNavigationBar()
    configureSearchTextField()
    configureBottomBar()
    setupDependencies()
    
    presenter?.viewDidLoad()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    navigationController?.navigationBar.prefersLargeTitles = true
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
  
  private func setupNavigationItem() {
    navigationItem.title = "Задачи"
    navigationItem.hidesSearchBarWhenScrolling = false
  }
  
  private func setupNavigationBar() {
    navigationItem.title = Constants.navigationTitle
    navigationItem.searchController = searchController
    navigationItem.hidesSearchBarWhenScrolling = false
    
    let appearance = UINavigationBarAppearance()
    appearance.configureWithOpaqueBackground()
    appearance.backgroundColor = .black
    appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
    appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
    
    navigationController?.navigationBar.standardAppearance = appearance
    navigationController?.navigationBar.scrollEdgeAppearance = appearance
    navigationController?.navigationBar.compactAppearance = appearance
  }
  
  private func configureSearchTextField() {
    searchController.searchBar.searchTextField.textColor = .white
  }
  
  private func configureBottomBar() {
    bottomBarView.configure(onTapNewTaskButton: { [weak self] in
      self?.presenter?.didTapNewTaskButton()
    })
  }
  
  func setupDependencies() {
    dataSource = TaskListDataSource(tableView: tableView, presenter: presenter)
    delegate = TaskListDelegate(dataSource: dataSource, presenter: presenter)
    tableView.dataSource = dataSource
    tableView.delegate = delegate
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
      tableView.bottomAnchor.constraint(equalTo: bottomBarView.topAnchor)
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


// MARK: - UI Factory
private extension TaskListViewController {
  
  func makeTableView() -> UITableView {
    let tableView = UITableView()
    tableView.backgroundColor = .clear
    tableView.separatorColor = .gray
    tableView.separatorInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
    tableView.tableHeaderView = UIView()
    tableView.register(TaskCell.self, forCellReuseIdentifier: TaskCell.reuseIdentifier)
    return tableView
  }
  
  func makeSearchController() -> UISearchController {
    let searchController = UISearchController(searchResultsController: nil)
    searchController.searchResultsUpdater = self
    searchController.obscuresBackgroundDuringPresentation = false
    let searchBar = searchController.searchBar
    let searchField = searchBar.searchTextField

    searchField.backgroundColor = .primaryDarkGrayColor
    searchField.attributedPlaceholder = NSAttributedString(
      string: Constants.searchPlaceholder,
      attributes: [
        .foregroundColor: UIColor.primaryLightGrayColor,
        .font: UIFont.systemFont(ofSize: 19)
      ]
    )
    searchField.leftView?.tintColor = UIColor.primaryLightGrayColor
    
    let micImage = UIImage(systemName: "mic.fill")?
      .withTintColor(.primaryLightGrayColor, renderingMode: .alwaysOriginal)
    searchBar.setImage(micImage, for: .bookmark, state: .normal)
    searchBar.showsBookmarkButton = true
    
    return searchController
  }
}

// MARK: - TaskListViewProtocol
extension TaskListViewController: TaskListViewProtocol {
  
  func display(tasks: [Todo]) {
    dataSource.applySnapshot(tasks: tasks, animatingDifferences: true)
  }
  
  func displayTaskCount(_ count: Int) {
    bottomBarView.taskCount = count
  }
  
  func reload(tasks: [Todo]) {
    dataSource.reloadItems(tasks)
  }
}

// MARK: - UISearchResultsUpdating
extension TaskListViewController: UISearchResultsUpdating {
  
  func updateSearchResults(for searchController: UISearchController) {
    presenter?.filterTasks(with: searchController.searchBar.text ?? "")
  }
}

protocol TaskListViewControllerFactory {
  
  func makeTaskListViewController(using navigationController: UINavigationController) -> TaskListViewController
}
