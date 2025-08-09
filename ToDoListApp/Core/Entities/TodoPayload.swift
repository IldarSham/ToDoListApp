//
//  TodoPayload.swift
//  ToDoListApp
//
//  Created by Ildar Shamsullin on 08.08.2025.
//

import Foundation

struct TodoPayload: Decodable {
  let id: Int
  let todo: String
  let completed: Bool
  let userId: Int
}
