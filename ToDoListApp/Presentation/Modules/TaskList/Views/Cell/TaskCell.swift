//
//  TaskCell.swift
//  ToDoListApp
//
//  Created by Ildar Shamsullin on 04.08.2025.
//

import UIKit

struct TaskCellModel {
  let title: String
  let description: String
  let date: String
  let isCompleted: Bool
}

class TaskCell: UITableViewCell {
  
  // MARK: - Properties
  
  private let checkmarkButton: UIButton = {
    let button = UIButton(type: .custom)
    let config = UIImage.SymbolConfiguration(pointSize: 28, weight: .thin)
    
    // Normal state
    button.setImage(
      UIImage(systemName: "circle", withConfiguration: config)?
        .withTintColor(.gray, renderingMode: .alwaysOriginal),
      for: .normal
    )
    
    // Selected state
    button.setImage(
      UIImage(systemName: "checkmark.circle", withConfiguration: config)?
        .withTintColor(.systemYellow, renderingMode: .alwaysOriginal),
      for: .selected
    )
    
    button.setContentHuggingPriority(.required, for: .horizontal)
    return button
  }()
  
  private lazy var cellStack: UIStackView = {
    let stack = UIStackView(arrangedSubviews: [
      checkmarkButton,
      contentStack
    ])
    stack.axis = .horizontal
    stack.alignment = .top
    stack.spacing = 8
    return stack
  }()
  
  private lazy var contentStack: UIStackView = {
    let stack = UIStackView(arrangedSubviews: [
      titleLabel,
      descriptionLabel,
      dateLabel
    ])
    stack.axis = .vertical
    stack.isLayoutMarginsRelativeArrangement = true
    stack.layoutMargins = UIEdgeInsets(top: 4, left: 0, bottom: 0, right: 0)
    stack.spacing = 8
    return stack
  }()
  
  private let titleLabel: UILabel = {
    let label = UILabel()
    label.font = .systemFont(ofSize: 17, weight: .medium)
    label.textColor = .white
    label.numberOfLines = 1
    return label
  }()
  
  private let descriptionLabel: UILabel = {
    let label = UILabel()
    label.font = .systemFont(ofSize: 13, weight: .regular)
    label.textColor = .white
    label.numberOfLines = 0
    return label
  }()
  
  private let dateLabel: UILabel = {
    let label = UILabel()
    label.font = .systemFont(ofSize: 13, weight: .regular)
    label.textColor = .gray
    return label
  }()
  
  // MARK: - Initialization
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    setupAppearance()
    constructHierarchy()
    activateConstraints()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Public Methods
  
  public func configure(with model: TaskCellModel) {
    titleLabel.text = model.title
    descriptionLabel.text = model.description
    dateLabel.text = model.date
    checkmarkButton.isSelected = model.isCompleted
  }
  
  public func setCheckmarkHidden(_ hidden: Bool) {
    checkmarkButton.isHidden = hidden
  }
  
  // MARK: - Private Methods
  
  private func constructHierarchy() {
    contentView.addSubview(cellStack)
  }
}

// MARK: - View Setup
private extension TaskCell {
  
  func setupAppearance() {
    backgroundColor = .clear
  }
}

// MARK: - Layout
private extension TaskCell {
  
  func activateConstraints() {
    cellStack.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      cellStack.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor),
      cellStack.trailingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.trailingAnchor),
      cellStack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
      cellStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12),
    ])
  }
}
