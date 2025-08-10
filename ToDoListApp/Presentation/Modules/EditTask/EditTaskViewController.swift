//
//  EditTaskViewController.swift
//  ToDoListApp
//
//  Created by Ildar Shamsullin on 06.08.2025.
//

import UIKit

class EditTaskViewController: UIViewController {
  
  // MARK: - Properties
  
  var presenter: EditTaskPresenterProtocol?
  
  // MARK: - UI Elements
  
  private let scrollView = UIScrollView()
  private let contentView = UIView()
  
  private lazy var stackView: UIStackView = {
    let stack = UIStackView(arrangedSubviews: [titleTextView, dateLabel, descriptionTextView])
    stack.axis = .vertical
    stack.spacing = 10
    return stack
  }()
  
  private let titleTextView: UITextView = {
    let textView = UITextView()
    textView.font = .systemFont(ofSize: 34, weight: .bold)
    textView.textColor = .white
    textView.backgroundColor = .clear
    textView.isScrollEnabled = false
    textView.textContainer.lineFragmentPadding = 0
    textView.textContainerInset = .zero
    return textView
  }()
  
  private let dateLabel: UILabel = {
    let label = UILabel()
    label.font = .systemFont(ofSize: 13, weight: .regular)
    label.textColor = .primaryGrayColor
    return label
  }()
  
  private let descriptionTextView: UITextView = {
    let textView = UITextView()
    textView.font = .systemFont(ofSize: 16, weight: .regular)
    textView.textColor = .white
    textView.backgroundColor = .clear
    textView.isScrollEnabled = false
    textView.textContainer.lineFragmentPadding = 0
    textView.textContainerInset = .zero
    return textView
  }()
  
  // MARK: - Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupAppearance()
    constructHierarchy()
    activateConstraints()
    setupDelegates()
    setupTapGesture()
    configureTitleTextView()
    configureDateLabel()
    configureDescriptionTextView()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    setupNavigationBar()
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    focusTitleTextView()
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(true)
    saveEditingTask()
  }
  
  // MARK: - Private Methods
  
  @objc
  private func contentViewTapped() {
    descriptionTextView.becomeFirstResponder()
  }
  
  private func saveEditingTask() {
    let title = titleTextView.text ?? ""
    let description = descriptionTextView.text ?? ""
    presenter?.saveTask(title: title, description: description)
  }
}

// MARK: - View Setup
private extension EditTaskViewController {
  
  func setupAppearance() {
    view.backgroundColor = .black
  }
  
  func constructHierarchy() {
    contentView.addSubview(stackView)
    scrollView.addSubview(contentView)
    view.addSubview(scrollView)
  }
  
  private func setupNavigationBar() {
    navigationController?.navigationBar.prefersLargeTitles = false
    navigationController?.navigationBar.tintColor = .systemYellow
  }
  
  private func setupDelegates() {
    titleTextView.delegate = self
  }
  
  private func setupTapGesture() {
    let tapGesture = UITapGestureRecognizer(target: self, action: #selector(contentViewTapped))
    contentView.addGestureRecognizer(tapGesture)
  }
  
  func configureTitleTextView() {
    titleTextView.text = presenter?.initialTitle
  }
  
  func configureDateLabel() {
    dateLabel.text = presenter?.formattedDate
  }
  
  func configureDescriptionTextView() {
    descriptionTextView.text = presenter?.initialDescription
  }
  
  func focusTitleTextView() {
    titleTextView.becomeFirstResponder()
  }
}

// MARK: - EditTaskViewProtocol
extension EditTaskViewController: EditTaskViewProtocol {}

// MARK: - UITextViewDelegate
extension EditTaskViewController: UITextViewDelegate {
  func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
    if textView == titleTextView && text == "\n" {
      descriptionTextView.becomeFirstResponder()
      return false
    }
    return true
  }
}

// MARK: - Layout
private extension EditTaskViewController {
  
  func activateConstraints() {
    activateConstraintsScrollView()
    activateConstraintsContentView()
    activateConstraintsStackView()
  }
  
  func activateConstraintsScrollView() {
    scrollView.translatesAutoresizingMaskIntoConstraints = false
    
    let frameLayoutGuide = scrollView.frameLayoutGuide
    NSLayoutConstraint.activate([
      frameLayoutGuide.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      frameLayoutGuide.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      frameLayoutGuide.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
      frameLayoutGuide.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
    ])
  }
  
  func activateConstraintsContentView() {
    contentView.translatesAutoresizingMaskIntoConstraints = false
    
    let contentLayoutGuide = scrollView.contentLayoutGuide
    let frameLayoutGuide = scrollView.frameLayoutGuide
    
    NSLayoutConstraint.activate([
      contentView.leadingAnchor.constraint(equalTo: contentLayoutGuide.leadingAnchor),
      contentView.trailingAnchor.constraint(equalTo: contentLayoutGuide.trailingAnchor),
      contentView.topAnchor.constraint(equalTo: contentLayoutGuide.topAnchor),
      contentView.bottomAnchor.constraint(equalTo: contentLayoutGuide.bottomAnchor),
      
      contentView.widthAnchor.constraint(equalTo: frameLayoutGuide.widthAnchor),
      contentView.heightAnchor.constraint(greaterThanOrEqualTo: frameLayoutGuide.heightAnchor)
    ])
  }
  
  func activateConstraintsStackView() {
    stackView.translatesAutoresizingMaskIntoConstraints = false
    
    NSLayoutConstraint.activate([
      stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
      stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
      stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
      stackView.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -20)
    ])
  }
}

protocol EditTaskViewControllerFactory {
  
  func makeEditTaskViewController(editingTask: Todo?) -> EditTaskViewController
}
