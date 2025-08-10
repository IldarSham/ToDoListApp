//
//  StartPresenterTests.swift
//  ToDoListAppTests
//
//  Created by Ildar Shamsullin on 10.08.2025.
//

import XCTest
@testable import ToDoListApp
import CoreData

class StartPresenterTests: XCTestCase {
  
  // MARK: - Properties
  
  var sut: StartPresenter!
  
  var mockInteractor: MockStartInteractor!
  var mockRouter: MockStartRouter!
  
  // MARK: - Lifecycle
  
  override func setUpWithError() throws {
    try super.setUpWithError()
    sut = StartPresenter()
    mockInteractor = MockStartInteractor()
    mockRouter = MockStartRouter()
    
    sut.interactor = mockInteractor
    sut.router = mockRouter
  }
  
  override func tearDownWithError() throws {
    sut = nil
    mockInteractor = nil
    mockRouter = nil
    try super.tearDownWithError()
  }
  
  // MARK: - Methods
  
  func test_viewDidLoad_callsInteractorToSeedDatabase() {
    sut.viewDidLoad()
    XCTAssertTrue(mockInteractor.seedDatabaseIfNeededCalled)
  }
  
  func test_didFinishSeedingDatabase_forAnyResult_callsRouterToStartMainFlow() {
    let testCases: [SeedingResult] = [
      .success,
      .failure(DummyError()),
      .alreadySeeded
    ]
    
    testCases.forEach { result in
      mockRouter.startMainFlowCalled = false
            
      sut.didFinishSeedingDatabase(result: result)
      
      XCTAssertTrue(mockRouter.startMainFlowCalled)
    }
  }
}
