//
//  RemoteAPIManagerMock.swift
//  ToDoListAppTests
//
//  Created by Ildar Shamsullin on 10.08.2025.
//

import XCTest
@testable import ToDoListApp

class RemoteAPIManagerMock: RemoteAPIManagerProtocol {
  
  var callAPICalled = false
  private var receivedCompletion: Any!
  
  func callAPI<T: Decodable>(with data: RequestProtocol, completion: @escaping ApiResponseHandler<T>) {
    self.callAPICalled = true
    self.receivedCompletion = completion
  }
  
  func complete<T>(with result: Result<T, Error>) {
    guard let completion = receivedCompletion as? ApiResponseHandler<T> else {
      XCTFail("Failed to cast the completion handler to the expected type \(T.self)")
      return
    }
    completion(result)
  }
}
