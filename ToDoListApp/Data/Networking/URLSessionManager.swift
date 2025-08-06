//
//  URLSessionManager.swift
//  ToDoListApp
//
//  Created by Ildar Shamsullin on 06.08.2025.
//

import Foundation

protocol URLSessionManagerProtocol {
  func performRequest(_ urlRequest: URLRequest) async throws -> Data
}

class URLSessionManager: URLSessionManagerProtocol {
  
  private let urlSession: URLSession
  
  init(urlSession: URLSession = .shared) {
    self.urlSession = urlSession
  }
  
  func performRequest(_ urlRequest: URLRequest) async throws -> Data {
    let (data, response) = try await urlSession.data(for: urlRequest)
    if let httpResponse = response as? HTTPURLResponse,
       httpResponse.statusCode != 200 {
      throw NetworkError.invalidServerResponse(statusCode: httpResponse.statusCode)
    }
    return data
  }
}

enum NetworkError: Error {
  case invalidServerResponse(statusCode: Int)
}
