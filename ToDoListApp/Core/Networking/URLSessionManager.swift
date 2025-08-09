//
//  URLSessionManager.swift
//  ToDoListApp
//
//  Created by Ildar Shamsullin on 06.08.2025.
//

import Foundation

protocol URLSessionManagerProtocol {
  
  typealias ServerResponseHandler = (Result<Data, Error>) -> Void
  func performRequest(_ urlRequest: URLRequest, completion: @escaping ServerResponseHandler)
}

class URLSessionManager: URLSessionManagerProtocol {
  
  private let urlSession: URLSession
  
  init(urlSession: URLSession = .shared) {
    self.urlSession = urlSession
  }
  
  func performRequest(_ urlRequest: URLRequest, completion: @escaping ServerResponseHandler) {
    urlSession.dataTask(with: urlRequest) { (data, response, error) in
      let result: Result<Data, Error>
      defer {
        DispatchQueue.main.async {
          completion(result)
        }
      }
      if let response = response as? HTTPURLResponse, (200..<300) ~= response.statusCode {
        guard let data = data else { return result = .failure(NetworkError.invalidData) }
        result = .success(data)
      } else {
        result = .failure(NetworkError.invalidServerResponse)
      }
    }.resume()
  }
}

enum NetworkError: Error {
  case invalidServerResponse
  case invalidData
}
