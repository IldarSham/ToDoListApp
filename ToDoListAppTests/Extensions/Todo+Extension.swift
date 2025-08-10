//
//  Todo+Extension.swift
//  ToDoListAppTests
//
//  Created by Ildar Shamsullin on 10.08.2025.
//

import Foundation
import CoreData
@testable import ToDoListApp

extension Todo {
  
  static func makeMock(title: String, content: String? = nil, date: Date = .now) -> Todo {
    let todo = NSEntityDescription.insertNewObject(forEntityName: String(describing: Todo.self),
                                                   into: TestCoreDataStack.instance.context) as! Todo
    todo.title = title
    todo.content = content
    todo.date = date
    return todo
  }
}
