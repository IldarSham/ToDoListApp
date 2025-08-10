//
//  TaskListInteractorTests.swift
//  ToDoListAppTests
//
//  Created by Ildar Shamsullin on 10.08.2025.
//

import XCTest
import CoreData
@testable import ToDoListApp

class TaskListInteractorTests: XCTestCase {
  
  // MARK: - Properties
  
  var sut: TaskListInteractor!
  
  var mockPresenter: TaskListInteractorOutputMock!
  var mockRepository: RepositoryMock<Todo>!
  
  // MARK: - Lifecycle
  
  override func setUpWithError() throws {
    try super.setUpWithError()
    mockPresenter = TaskListInteractorOutputMock()
    mockRepository = RepositoryMock<Todo>()
    sut = TaskListInteractor(repository: mockRepository)
    sut.presenter = mockPresenter
  }
  
  override func tearDownWithError() throws {
    sut = nil
    mockPresenter = nil
    mockRepository = nil
    try super.tearDownWithError()
  }
  
  // MARK: - Methods
  
  func test_fetchTaskList_onSuccess_shouldPassFetchedTodosToPresenter() {
    let sampleTodos = [Todo.makeMock(title: "Test Task 1"), Todo.makeMock(title: "Test Task 2")]
    
    sut.fetchTaskList()
    
    XCTAssertTrue(mockRepository.fetchCalled)
    XCTAssertEqual(mockRepository.receivedSortDescriptors.first?.key, #keyPath(Todo.date))
    XCTAssertEqual(mockRepository.receivedSortDescriptors.first?.ascending, false)
    
    mockRepository.fetchCompletion(.success(sampleTodos))
    
    XCTAssertEqual(mockPresenter.receivedResult, .fetched(sampleTodos))
  }
  
  func test_fetchTaskList_onFailure_shouldPassErrorToPresenter() {
    let sampleError = DummyError()
    
    sut.fetchTaskList()
    mockRepository.fetchCompletion?(.failure(sampleError))
    
    XCTAssertEqual(mockPresenter.receivedResult, .failure(sampleError))
  }
  
  func test_toggleCompletionStatus_onSuccess_shouldPassToggledToPresenter() {
    let taskToToggle = Todo.makeMock(title: "Toggle Me")
    
    sut.toggleCompletionStatus(for: taskToToggle)
    
    XCTAssertTrue(mockRepository.updateCalled)
    XCTAssertEqual(mockRepository.receivedObjectForUpdate, taskToToggle)
    
    mockRepository.updateCompletion(.success(taskToToggle))
    
    XCTAssertEqual(mockPresenter.receivedResult, .toggled(taskToToggle))
  }
  
  func test_deleteTask_onSuccess_shouldPassDeletedToPresenter() {
    let taskToDelete = Todo.makeMock(title: "Delete Me")
    
    sut.deleteTask(taskToDelete)
    
    XCTAssertTrue(mockRepository.deleteCalled)
    XCTAssertEqual(mockRepository.receivedObjectForDelete, taskToDelete)
    
    mockRepository.deleteCompletion(.success(()))
    
    XCTAssertEqual(mockPresenter.receivedResult, .deleted(taskToDelete))
  }
}
