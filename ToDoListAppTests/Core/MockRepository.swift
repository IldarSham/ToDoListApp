//
//  MockRepository.swift
//  ToDoListAppTests
//
//  Created by Ildar Shamsullin on 10.08.2025.
//

import CoreData
@testable import ToDoListApp

class RepositoryMock<T: NSManagedObject>: RepositoryProtocol {
  var fetchCalled = false
  var updateCalled = false
  var deleteCalled = false
  var createCalled = false
  var createBatchCalled = false
  
  var receivedPredicate: NSPredicate!
  var receivedSortDescriptors: [NSSortDescriptor]!
  var receivedObjectForUpdate: T!
  var receivedObjectForDelete: T!
  var receivedItemsForCreateBatch: Any!
  
  var fetchCompletion: ((Result<[T], Error>) -> Void)!
  var updateCompletion: ((Result<T, Error>) -> Void)!
  var deleteCompletion: ((Result<Void, Error>) -> Void)!
  var createCompletion: ((Result<T, Error>) -> Void)!
  var batchCompletion: ((Result<[T], Error>) -> Void)!

  func fetch(predicate: NSPredicate?, sort: [NSSortDescriptor], completion: @escaping (Result<[T], any Error>) -> Void) {
    fetchCalled = true
    receivedPredicate = predicate
    receivedSortDescriptors = sort
    fetchCompletion = completion
  }
  
  func update(object: T, changes: @escaping (T) -> Void, completion: @escaping (Result<T, any Error>) -> Void) {
    updateCalled = true
    receivedObjectForUpdate = object
    updateCompletion = completion
  }
  
  func delete(object: T, completion: @escaping (Result<Void, Error>) -> Void) {
    deleteCalled = true
    receivedObjectForDelete = object
    deleteCompletion = completion
  }
  
  func create(configure: @escaping (T) -> Void, completion: @escaping (Result<T, Error>) -> Void) {
    createCalled = true
    createCompletion = completion
  }
  
  func createBatch<U>(items: [U], configure: @escaping (T, U) -> Void, completion: @escaping (Result<[T], Error>) -> Void) {
    createBatchCalled = true
    receivedItemsForCreateBatch = items
    batchCompletion = completion
  }
}
