//
//  ReuseIdentifiable.swift
//  ToDoListApp
//
//  Created by Ildar Shamsullin on 04.08.2025.
//

import UIKit

protocol ReuseIdentifiable: AnyObject {
  static var reuseIdentifier: String { get }
}

extension ReuseIdentifiable {
  static var reuseIdentifier: String { .init(describing: self) }
}

extension UITableViewCell: ReuseIdentifiable {}
