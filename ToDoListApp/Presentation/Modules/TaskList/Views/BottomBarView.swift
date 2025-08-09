//
//  BottomBarView.swift
//  ToDoListApp
//
//  Created by Ildar Shamsullin on 05.08.2025.
//

import UIKit

class BottomBarView: UIView {
  
  // MARK: - Properties
  
  public var taskCount: Int = 0 {
    didSet {
      updateTaskCount()
    }
  }
  
  private var didTapNewTaskButton: (() -> Void)?
  
  // MARK: - UI Elements
  
  private let taskCountLabel: UILabel = {
    let label = UILabel()
    label.textColor = .white
    label.font = .systemFont(ofSize: 11, weight: .regular)
    return label
  }()
  
  private lazy var newTaskButton: UIButton = {
    let button = UIButton(type: .system)
    let configuration = UIImage.SymbolConfiguration(pointSize: 20, weight: .medium)
    button.setImage(UIImage(systemName: "square.and.pencil", withConfiguration: configuration), for: .normal)
    button.tintColor = .systemYellow
    button.addTarget(self, action: #selector(handleNewTaskButtonTap), for: .touchUpInside)
    return button
  }()
  
  // MARK: - Initialization
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupAppearance()
    constructHierarchy()
    activateConstraints()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Public Methods
  
  public func configure(taskCount: Int = 0, onTapNewTaskButton: @escaping () -> Void) {
    self.taskCount = taskCount
    self.didTapNewTaskButton = onTapNewTaskButton
  }
  
  // MARK: - Private Methods
  
  private func updateTaskCount() {
    taskCountLabel.text = "\(taskCount) Задач"
  }
  
  @objc
  private func handleNewTaskButtonTap() {
    didTapNewTaskButton?()
  }
}

// MARK: - View Setup
private extension BottomBarView {
  
  func setupAppearance() {
    backgroundColor = .primaryDarkGrayColor
  }
  
  func constructHierarchy() {
    addSubview(taskCountLabel)
    addSubview(newTaskButton)
  }
}

// MARK: - Layout
private extension BottomBarView {
  
  func activateConstraints() {
    activateConstraintsTaskCountLabel()
    activateConstraintsNewTaskButton()
  }
  
  func activateConstraintsTaskCountLabel() {
    taskCountLabel.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      taskCountLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
      taskCountLabel.leadingAnchor.constraint(greaterThanOrEqualTo: leadingAnchor, constant: 20),
      taskCountLabel.trailingAnchor.constraint(lessThanOrEqualTo: newTaskButton.leadingAnchor, constant: -5),
      taskCountLabel.topAnchor.constraint(equalTo: topAnchor, constant: 20)
    ])
  }
  
  func activateConstraintsNewTaskButton() {
    newTaskButton.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      newTaskButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
      newTaskButton.centerYAnchor.constraint(equalTo: taskCountLabel.centerYAnchor)
    ])
  }
}
