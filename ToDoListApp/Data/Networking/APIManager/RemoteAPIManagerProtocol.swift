//
//  RemoteAPIManagerProtocol.swift
//  ToDoListApp
//
//  Created by Ildar Shamsullin on 06.08.2025.
//

import Foundation

protocol RemoteAPIManagerProtocol {
  func callAPI<T: Decodable>(with data: RequestProtocol) async throws -> T
}
