//
//  EditTaskInteractorTests.swift
//  ToDoListAppTests
//
//  Created by Ildar Shamsullin on 10.08.2025.
//

import XCTest
@testable import ToDoListApp

final class EditTaskInteractorTests: XCTestCase {
  
  // MARK: - Properties
  
  var sut: EditTaskInteractor!
  
  var mockPresenter: EditTaskInteractorOutputMock!
  var mockRepository: RepositoryMock<Todo>!
  
  // MARK: - Lifecycle
  
  override func setUpWithError() throws {
    try super.setUpWithError()
    mockPresenter = EditTaskInteractorOutputMock()
    mockRepository =  RepositoryMock<Todo>()
  }
  
  override func tearDownWithError() throws {
    sut = nil
    mockPresenter = nil
    mockRepository = nil
    try super.tearDownWithError()
  }
  
  // MARK: - Methods
  
  func test_persistTask_withEmptyTitle_shouldDoNothing() {
    sut = makeEditTaskInteractor(editingTask: nil)
    
    sut.persistTask(title: "", description: "Some description")
    
    XCTAssertFalse(mockRepository.createCalled)
    XCTAssertFalse(mockRepository.updateCalled)
    XCTAssertNil(mockPresenter.receivedResult)
  }
  
  func test_persistTask_forNewTask_onSuccess_shouldCallCreateAndNotifyPresenter() {
    sut =  makeEditTaskInteractor(editingTask: nil)
    let newTask = Todo.makeMock(title: "New Task")
    
    sut.persistTask(title: "New Task", description: "Description")
    
    XCTAssertTrue(mockRepository.createCalled)
    XCTAssertFalse(mockRepository.updateCalled)
    
    mockRepository.createCompletion(.success(newTask))
    
    XCTAssertEqual(mockPresenter.receivedResult, .created(newTask))
  }
  
  func test_persistTask_forNewTask_onFailure_shouldNotifyPresenterOfError() {
    sut = makeEditTaskInteractor(editingTask: nil)
    let error = DummyError()
    
    sut.persistTask(title: "New Task", description: "Description")
    mockRepository.createCompletion(.failure(error))
    
    XCTAssertEqual(mockPresenter.receivedResult, .failure(error))
  }
  
  func test_persistTask_forExistingTask_onSuccess_shouldCallUpdateAndNotifyPresenter() {
    let existingTask = Todo.makeMock(title: "Old Title")
    sut = makeEditTaskInteractor(editingTask: existingTask)
    
    sut.persistTask(title: "New Title", description: "New Description")
    
    XCTAssertTrue(mockRepository.updateCalled)
    XCTAssertFalse(mockRepository.createCalled)
    XCTAssertEqual(mockRepository.receivedObjectForUpdate, existingTask)
    
    let updatedTask = Todo.makeMock(title: "New Title")
    mockRepository.updateCompletion(.success(updatedTask))
    
    XCTAssertEqual(mockPresenter.receivedResult, .updated(updatedTask))
  }
  
  func test_persistTask_forExistingTask_onFailure_shouldNotifyPresenterOfError() {
    let existingTask = Todo.makeMock(title: "Old Title")
    sut = makeEditTaskInteractor(editingTask: existingTask)
    let error = DummyError()

    sut.persistTask(title: "New Title", description: "New Description")
    mockRepository.updateCompletion(.failure(error))
    
    XCTAssertEqual(mockPresenter.receivedResult, .failure(error))
  }
  
  // MARK: - Helpers
  
  private func makeEditTaskInteractor(editingTask: Todo?) -> EditTaskInteractor {
    let interactor = EditTaskInteractor(editingTask: editingTask, repository: mockRepository)
    interactor.presenter = mockPresenter
    return interactor
  }
}
