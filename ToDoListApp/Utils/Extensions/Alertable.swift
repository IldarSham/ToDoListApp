//
//  Alertable.swift
//  ToDoListApp
//
//  Created by Ildar Shamsullin on 10.08.2025.
//

import UIKit

protocol Alertable {
  func presentAlert(title: String?, message: String?)
}

extension Alertable where Self: UIViewController {
  func presentAlert(title: String?, message: String?) {
    let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
    alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
    present(alertController, animated: true, completion: nil)
  }
}

extension Alertable {
  func presentAlert(title: String?, message: String?) {}
}
