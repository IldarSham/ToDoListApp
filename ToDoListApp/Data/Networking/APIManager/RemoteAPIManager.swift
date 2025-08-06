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
  
  public init(urlSessionManager: URLSessionManagerProtocol = URLSessionManager()) {
    self.urlSessionManager = urlSessionManager
  }
  
  // MARK: - Public Methods
  
  public func callAPI<T: Decodable>(
    with data: RequestProtocol,
    completion: @escaping ApiResponseHandler<T>
  ) {
    guard let urlRequest = try? makeRequest(with: data) else {
      completion(.failure(RemoteAPIManagerError.invalidURL))
      return
    }
    
    urlSessionManager.performRequest(urlRequest) { [weak self] response in
      switch response {
      case .success(let data):
        if let decoded = try? self?.decoder.decode(T.self, from: data) {
          completion(.success(decoded))
        } else {
          completion(.failure(RemoteAPIManagerError.decodingFailed))
        }
      case .failure(let error):
        completion(.failure(error))
      }
    }
  }
  
  private func makeRequest(with data: RequestProtocol) throws -> URLRequest {
    let url = try buildURL(with: data)
    var request = URLRequest(url: url)
    request.httpMethod = HTTPMethod.get.rawValue
    return request
  }
  
  // MARK: - Private Methods
  
  private func buildURL(with data: RequestProtocol) throws -> URL {
    var components = URLComponents(string: baseURL)
    components?.path = data.path
    
    guard let url = components?.url else {
      throw RemoteAPIManagerError.invalidURL
    }
    
    return url
  }
}

enum RemoteAPIManagerError: Error {
  case invalidURL
  case decodingFailed
}
