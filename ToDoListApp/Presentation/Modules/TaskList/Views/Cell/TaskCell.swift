//
//  TaskCell.swift
//  ToDoListApp
//
//  Created by Ildar Shamsullin on 04.08.2025.
//

import UIKit

struct TaskCellViewModel {
  let title: String
  let description: String?
  let date: String
  var isCompleted: Bool
}

class TaskCell: UITableViewCell {
  
  // MARK: - Properties
  
  public var isTaskCompleted: Bool = false {
    didSet {
      updateStyle()
    }
  }
  
  private var didTapCheckmarkButton: (() -> Void)?

  // MARK: - UI Elements
  
  private lazy var checkmarkButton: UIButton = {
    let button = UIButton(type: .custom)
    let config = UIImage.SymbolConfiguration(pointSize: 28, weight: .thin)
    
    button.setImage(
      UIImage(systemName: "circle", withConfiguration: config)?
        .withTintColor(.gray, renderingMode: .alwaysOriginal),
      for: .normal
    )
    
    button.setImage(
      UIImage(systemName: "checkmark.circle", withConfiguration: config)?
        .withTintColor(.systemYellow, renderingMode: .alwaysOriginal),
      for: .selected
    )
    
    button.addTarget(self, action: #selector(handleCheckmarkButtonTap), for: .touchUpInside)
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
    label.numberOfLines = 0
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
  
  override func prepareForReuse() {
    super.prepareForReuse()
    titleLabel.attributedText = nil
  }
  
  // MARK: - Public Methods
  
  public func configure(with viewModel: TaskCellViewModel, onCheckmarkButtonTap: @escaping () -> Void) {
    titleLabel.text = viewModel.title
    descriptionLabel.text = viewModel.description
    dateLabel.text = viewModel.date
    checkmarkButton.isSelected = viewModel.isCompleted
    isTaskCompleted = viewModel.isCompleted
    didTapCheckmarkButton = onCheckmarkButtonTap
  }
  
  public func setCheckmarkHidden(_ hidden: Bool) {
    checkmarkButton.isHidden = hidden
  }
  
  // MARK: - Private Methods
  
  private func updateStyle() {
    if isTaskCompleted {
      titleLabel.attributedText = strikeThrough(text: titleLabel.text ?? "")
      titleLabel.textColor = .primaryGrayColor
      descriptionLabel.textColor = .primaryGrayColor
    } else {
      titleLabel.attributedText = NSAttributedString(string: titleLabel.text ?? "")
      titleLabel.textColor = .white
      descriptionLabel.textColor = .white
    }
  }

  private func strikeThrough(text: String) -> NSAttributedString {
    let attributes: [NSAttributedString.Key: Any] = [
      .strikethroughStyle: NSUnderlineStyle.single.rawValue
    ]
    return NSAttributedString(string: text, attributes: attributes)
  }

  @objc
  private func handleCheckmarkButtonTap() {
    didTapCheckmarkButton?()
  }
}

// MARK: - View Setup
private extension TaskCell {
  
  func setupAppearance() {
    backgroundColor = .clear
  }
  
  func constructHierarchy() {
    contentView.addSubview(cellStack)
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
