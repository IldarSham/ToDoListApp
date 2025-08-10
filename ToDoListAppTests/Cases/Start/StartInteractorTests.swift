//
//  StartInteractorTests.swift
//  ToDoListAppTests
//
//  Created by Ildar Shamsullin on 10.08.2025.
//

import XCTest
@testable import ToDoListApp

final class StartInteractorTests: XCTestCase {
  
  // MARK: - Properties
  
  var sut: StartInteractor!
  
  var mockPresenter: MockStartInteractorOutput!
  var mockStorage: MockSeedDataStatusStorage!
  var mockApiManager: RemoteAPIManagerMock!
  var mockRepository: RepositoryMock<Todo>!
  
  // MARK: - Lifecycle
  
  override func setUpWithError() throws {
    try super.setUpWithError()
    mockPresenter = MockStartInteractorOutput()
    mockStorage = MockSeedDataStatusStorage()
    mockApiManager = RemoteAPIManagerMock()
    mockRepository = RepositoryMock<Todo>()
    
    sut = StartInteractor(
      storage: mockStorage,
      apiManager: mockApiManager,
      repository: mockRepository
    )
    sut.presenter = mockPresenter
  }
  
  override func tearDownWithError() throws {
    sut = nil
    mockPresenter = nil
    mockStorage = nil
    mockApiManager = nil
    mockRepository = nil
    try super.tearDownWithError()
  }
  
  // MARK: - Methods
  
  func test_seedDatabaseIfNeeded_whenAlreadySeeded_shouldReturnImmediately() {
    mockStorage.isSeedDataCompleted = true
    
    sut.seedDatabaseIfNeeded()
    
    XCTAssertEqual(mockPresenter.receivedResult, .alreadySeeded)
    
    XCTAssertFalse(mockApiManager.callAPICalled)
    XCTAssertFalse(mockRepository.createBatchCalled)
  }
  
  func test_seedDatabaseIfNeeded_fullSuccessPath_shouldFetchSaveAndNotifyPresenter() {
    mockStorage.isSeedDataCompleted = false
    
    let apiResponse = Page(todos: [TodoPayload(id: 1, todo: "Task 1", completed: false, userId: 1)])
    let expectedTodos = [Todo.makeMock(title: "Task 1")]
        
    sut.seedDatabaseIfNeeded()
    
    XCTAssertTrue(mockApiManager.callAPICalled)
    XCTAssertFalse(mockRepository.createBatchCalled)
    
    mockApiManager.complete(with: .success(apiResponse))
    
    XCTAssertTrue(mockRepository.createBatchCalled)
    
    let receivedItems = mockRepository.receivedItemsForCreateBatch as? [TodoPayload]
    XCTAssertEqual(receivedItems?.count, 1)
    XCTAssertEqual(receivedItems?.first?.todo, "Task 1")
    
    mockRepository.batchCompletion(.success(expectedTodos))
    
    XCTAssertTrue(mockStorage.isSeedDataCompleted)
    XCTAssertEqual(mockPresenter.receivedResult, .success)
  }
  
  func test_seedDatabaseIfNeeded_whenApiFails_shouldNotifyPresenterOfError() {
    mockStorage.isSeedDataCompleted = false
    let apiError = DummyError()
    
    sut.seedDatabaseIfNeeded()
    
    let result: Result<Page<TodoPayload>, Error> = .failure(apiError)
    mockApiManager.complete(with: result)
    
    XCTAssertEqual(mockPresenter.receivedResult, .failure(apiError))
    
    XCTAssertFalse(mockRepository.createBatchCalled)
    XCTAssertFalse(mockStorage.isSeedDataCompleted)
  }
  
  func test_seedDatabaseIfNeeded_whenRepositoryFails_shouldNotifyPresenterOfError() {
    mockStorage.isSeedDataCompleted = false
    
    let apiResponse = Page(todos: [TodoPayload(id: 1, todo: "Task 1", completed: false, userId: 1)])
    let repoError = DummyError()
    
    sut.seedDatabaseIfNeeded()
    mockApiManager.complete(with: .success(apiResponse))
    
    mockRepository.batchCompletion(.failure(repoError))
    
    XCTAssertEqual(mockPresenter.receivedResult, .failure(repoError))
    XCTAssertFalse(mockStorage.isSeedDataCompleted)
  }
}
