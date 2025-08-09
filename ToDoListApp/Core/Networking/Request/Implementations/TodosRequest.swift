//
//  TodosRequest.swift
//  ToDoListApp
//
//  Created by Ildar Shamsullin on 06.08.2025.
//

import Foundation

struct TodosRequest: RequestProtocol {
  var path: String {
    return "/todos"
  }
}
