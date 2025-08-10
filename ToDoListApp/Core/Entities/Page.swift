//
//  Page.swift
//  ToDoListApp
//
//  Created by Ildar Shamsullin on 08.08.2025.
//

import Foundation

struct Page<T: Decodable>: Decodable {
  let todos: [T]
}
