//
//  UserDefaultsLayer.swift
//  ToDoListApp
//
//  Created by Ildar Shamsullin on 08.08.2025.
//

import Foundation

protocol SeedDataStatusStorage: AnyObject {
  var isSeedDataCompleted: Bool { get set }
}

class UserDefaultsLayer: SeedDataStatusStorage {
  @Persist(key: "seed_data_completed", defaultValue: false)
  var isSeedDataCompleted: Bool
}
