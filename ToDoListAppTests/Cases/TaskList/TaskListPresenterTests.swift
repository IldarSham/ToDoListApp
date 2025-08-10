//
//  TaskListPresenterTests.swift
//  ToDoListAppTests
//
//  Created by Ildar Shamsullin on 10.08.2025.
//

import XCTest
import CoreData
@testable import ToDoListApp

class TaskListPresenterTests: XCTestCase {
  
  // MARK: - Properties
  
  var sut: TaskListPresenter!
  
  var mockView: TaskListViewMock!
  var mockInteractor: TaskListInteractorInputMock!
  var mockRouter: TaskListRouterMock!
    
  // MARK: - Lifecycle
  
  override func setUpWithError() throws {
    try super.setUpWithError()
    sut = TaskListPresenter()
    mockView = TaskListViewMock()
    mockInteractor = TaskListInteractorInputMock()
    mockRouter = TaskListRouterMock()
    
    sut.view = mockView
    sut.interactor = mockInteractor
    sut.router = mockRouter
  }
  
  override func tearDownWithError() throws {
    sut = nil
    mockView = nil
    mockInteractor = nil
    mockRouter = nil
    try super.tearDownWithError()
  }
  
  // MARK: - Methods
  
  func test_viewDidLoad_shouldFetchTasksFromInteractor() {
    sut.viewDidLoad()
    
    XCTAssertTrue(mockInteractor.fetchTaskListCalled)
  }
  
  func test_didTapNewTaskButton_shouldShowEditScreenForNewTask() {
    sut.didTapNewTaskButton()
    
    XCTAssertTrue(mockRouter.wasCalledForNewTask)
  }
  
  func test_didSelectEditAction_shouldShowEditScreenWithCorrectTask() {
    let todoToEdit = Todo.makeMock(title: "Task to Edit")
    
    sut.didSelectEditAction(for: todoToEdit)
    
    XCTAssertEqual(mockRouter.shownTodoForEdit, todoToEdit)
  }
  
  func test_didSelectDeleteAction_shouldRequestDeletionFromInteractor() {
    let todoToDelete = Todo.makeMock(title: "Task to Delete")
    
    sut.didSelectDeleteAction(for: todoToDelete)
    
    XCTAssertEqual(mockInteractor.deletedTodo, todoToDelete)
  }
  
  func test_didTapCheckmarkButton_shouldRequestToggleFromInteractor() {
    let todoToToggle = Todo.makeMock(title: "Task to Toggle")
    
    sut.didTapCheckmarkButton(for: todoToToggle)
    
    XCTAssertEqual(mockInteractor.toggledTodo, todoToToggle)
  }
  
  func test_didFinishFetchingTasks_shouldDisplayTasksInView() {
    let todos = [Todo.makeMock(title: "First"), Todo.makeMock(title: "Second")]
    
    sut.didFinishTaskOperation(result: .fetched(todos))
    
    XCTAssertEqual(mockView.displayedTasks.count, 2)
    XCTAssertEqual(mockView.displayedTasks.first?.title, "First")
    XCTAssertEqual(mockView.displayedTaskCount, 2)
  }
  
  func test_didFinishDeletingTask_shouldUpdateView() {
    let initialTodos = [Todo.makeMock(title: "One"), Todo.makeMock(title: "Two")]
    let todoToDelete = initialTodos[0]
    
    sut.didFinishTaskOperation(result: .fetched(initialTodos))
    sut.didFinishTaskOperation(result: .deleted(todoToDelete))
    
    XCTAssertEqual(mockView.displayedTasks.count, 1)
    XCTAssertFalse(mockView.displayedTasks.contains(todoToDelete))
    XCTAssertEqual(mockView.displayedTaskCount, 1)
  }
  
  func test_filterTasks_shouldDisplayFilteredTasks() {
    let todos = [
      Todo.makeMock(title: "Apple"),
      Todo.makeMock(title: "Banana"),
      Todo.makeMock(title: "Apricot")
    ]

    sut.didFinishTaskOperation(result: .fetched(todos))
    XCTAssertEqual(mockView.displayedTasks.count, 3)
    
    sut.filterTasks(with: "Ap")
    
    XCTAssertEqual(mockView.displayedTasks.count, 2)
    XCTAssertTrue(mockView.displayedTasks.allSatisfy { $0.title.contains("Ap") })
    XCTAssertEqual(mockView.displayedTaskCount, 3)
  }
  
  func test_filterTasks_withEmptyText_shouldDisplayAllTasks() {
    let todos = [Todo.makeMock(title: "Apple"), Todo.makeMock(title: "Banana")]
    
    sut.didFinishTaskOperation(result: .fetched(todos))
    
    sut.filterTasks(with: "Apple")
    XCTAssertEqual(mockView.displayedTasks.count, 1)
    
    sut.filterTasks(with: "")
    XCTAssertEqual(mockView.displayedTasks.count, 2)
  }
}
