//
//  RemoteAPIManagerProtocol.swift
//  ToDoListApp
//
//  Created by Ildar Shamsullin on 06.08.2025.
//

import Foundation

protocol RemoteAPIManagerProtocol {
  
  typealias ApiResponseHandler<T> = (Result<T, Error>) -> Void
  func callAPI<T: Decodable>(with data: RequestProtocol, completion: @escaping ApiResponseHandler<T>)
}
