//
//  RemoteAPIManager.swift
//  ToDoListApp
//
//  Created by Ildar Shamsullin on 06.08.2025.
//

import Foundation

class RemoteAPIManager: RemoteAPIManagerProtocol {
  
  // MARK: - Properties
  
  private let baseURL = "https://dummyjson.com"
  
  private let urlSessionManager: URLSessionManagerProtocol
  
  private let decoder: JSONDecoder = {
    let decoder = JSONDecoder()
    decoder.keyDecodingStrategy = .convertFromSnakeCase
    return decoder
  }()
  
  // MARK: - Initialization
  
  init(urlSessionManager: URLSessionManagerProtocol = URLSessionManager(urlSession: .shared)) {
    self.urlSessionManager = urlSessionManager
  }
  
  // MARK: - Public Methods
  
  func callAPI<T: Decodable>(with data: RequestProtocol) async throws -> T {
    let urlRequest = try makeRequest(with: data)
    
    do {
      let data = try await urlSessionManager.performRequest(urlRequest)
      return try decoder.decode(T.self, from: data)
    } catch let error as NetworkError {
      throw error
    }
  }
  
  private func makeRequest(with data: RequestProtocol) throws -> URLRequest {
    let url = try buildURL(with: data)
    
    var urlRequest = URLRequest(url: url)
    urlRequest.httpMethod = HTTPMethod.get.rawValue
    
    return urlRequest
  }
  
  // MARK: - Private Methods
  
  private func buildURL(with data: RequestProtocol) throws -> URL {
    var components = URLComponents(string: baseURL)!
    components.path = data.path
    
    if let url = components.url {
      return url
    } else {
      throw RemoteAPIManagerError.invalidURL
    }
  }
}

enum RemoteAPIManagerError: Error {
  case invalidURL
}
