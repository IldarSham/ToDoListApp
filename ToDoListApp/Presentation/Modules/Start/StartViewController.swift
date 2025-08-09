//
//  StartViewController.swift
//  ToDoListApp
//
//  Created by Ildar Shamsullin on 08.08.2025.
//

import UIKit

class StartViewController: UIViewController {
  
  // MARK: - Properties
  
  var presenter: StartPresenterProtocol?
  
  // MARK: - UI Elements
  
  private let activityIndicator: UIActivityIndicatorView = {
    let indicator = UIActivityIndicatorView(style: .large)
    indicator.color = .white
    indicator.hidesWhenStopped = true
    indicator.startAnimating()
    return indicator
  }()
  
  // MARK: - Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupAppearance()
    constructHierarchy()
    activateConstraints()
    
    presenter?.viewDidLoad()
  }
}

// MARK: - View Setup
private extension StartViewController {
  
  func setupAppearance() {
    view.backgroundColor = .black
  }
  
  func constructHierarchy() {
    view.addSubview(activityIndicator)
  }
}

// MARK: - Layout
private extension StartViewController {
  
  func activateConstraints() {
    activityIndicator.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
    ])
  }
}

protocol StartViewControllerFactory {
  
  func makeStartViewController(router: StartRouterProtocol) -> StartViewController
}
