//
//  EditTaskPresenterTests.swift
//  ToDoListAppTests
//
//  Created by Ildar Shamsullin on 10.08.2025.
//

import XCTest
@testable import ToDoListApp

final class EditTaskPresenterTests: XCTestCase {
  
  // MARK: - Properties
  
  var sut: EditTaskPresenter!
  
  var mockInteractor: EditTaskInteractorInputMock!
  var mockDelegate: EditTaskModuleDelegateMock!
  
  // MARK: - Lifecycle
  
  override func setUpWithError() throws {
    try super.setUpWithError()
    sut = EditTaskPresenter()
    mockInteractor = EditTaskInteractorInputMock()
    mockDelegate = EditTaskModuleDelegateMock()

    sut.interactor = mockInteractor
    sut.delegate = mockDelegate
  }
  
  // MARK: - Methods
  
  override func tearDownWithError() throws {
    sut = nil
    mockInteractor = nil
    mockDelegate = nil
    try super.tearDownWithError()
  }
  
  func test_initialState_whenCreatingNewTask_providesDefaultValues() {
    mockInteractor.editingTask = nil
    
    XCTAssertEqual(sut.initialTitle, "")
    XCTAssertNil(sut.initialDescription)
    XCTAssertNotNil(sut.formattedDate)
    XCTAssertFalse(sut.formattedDate.isEmpty)
  }
  
  func test_initialState_whenEditingExistingTask_providesTaskValues() {
    let existingTask = Todo.makeMock(
      title: "Existing Title",
      content: "Existing Description",
      date: Date()
    )
    mockInteractor.editingTask = existingTask
    
    XCTAssertEqual(sut.initialTitle, "Existing Title")
    XCTAssertEqual(sut.initialDescription, "Existing Description")
    XCTAssertEqual(sut.formattedDate, existingTask.date.formattedAsString())
  }
  
  func test_saveTask_shouldCallInteractorToPersistTask() {
    let titleToSave = "New Title"
    let descriptionToSave = "New Description"
    
    sut.saveTask(title: titleToSave, description: descriptionToSave)
    
    XCTAssertTrue(mockInteractor.persistTaskCalled)
    XCTAssertEqual(mockInteractor.receivedTitle, titleToSave)
    XCTAssertEqual(mockInteractor.receivedDescription, descriptionToSave)
  }

  func test_didFinishEditing_withCreatedResult_shouldCallDelegateDidCreateTask() {
    let createdTask = Todo.makeMock(title: "Created")
    
    sut.didFinishEditingTask(result: .created(createdTask))
    
    XCTAssertEqual(mockDelegate.createdTask, createdTask)
    XCTAssertNil(mockDelegate.updatedTask)
  }
  
  func test_didFinishEditing_withUpdatedResult_shouldCallDelegateDidUpdateTask() {
    let updatedTask = Todo.makeMock(title: "Updated")
    
    sut.didFinishEditingTask(result: .updated(updatedTask))
    
    XCTAssertEqual(mockDelegate.updatedTask, updatedTask)
    XCTAssertNil(mockDelegate.createdTask)
  }
  
  func test_didFinishEditing_withFailureResult_shouldNotCallDelegate() {
    let error = DummyError()
    
    sut.didFinishEditingTask(result: .failure(error))
    
    XCTAssertNil(mockDelegate.createdTask)
    XCTAssertNil(mockDelegate.updatedTask)
  }
}
