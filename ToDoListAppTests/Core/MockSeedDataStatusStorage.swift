//
//  MockSeedDataStatusStorage.swift
//  ToDoListAppTests
//
//  Created by Ildar Shamsullin on 10.08.2025.
//

import Foundation
@testable import ToDoListApp

class MockSeedDataStatusStorage: SeedDataStatusStorage {
  var isSeedDataCompleted: Bool = false
}
