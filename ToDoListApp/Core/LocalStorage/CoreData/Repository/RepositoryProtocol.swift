//
//  RepositoryProtocol.swift
//  ToDoListApp
//
//  Created by Ildar Shamsullin on 10.08.2025.
//

import Foundation
import CoreData

protocol RepositoryProtocol<EntityType> {
  associatedtype EntityType: NSManagedObject
  
  func create(configure: @escaping (EntityType) -> Void, completion: @escaping (Result<EntityType, Error>) -> Void)
  func createBatch<U>(items: [U], configure: @escaping (EntityType, U) -> Void, completion: @escaping (Result<[EntityType], Error>) -> Void)
  func update(object: EntityType, changes: @escaping (EntityType) -> Void, completion: @escaping (Result<EntityType, Error>) -> Void)
  func delete(object: EntityType, completion: @escaping (Result<Void, Error>) -> Void)
  func fetch(predicate: NSPredicate?, sort: [NSSortDescriptor], completion: @escaping (Result<[EntityType], Error>) -> Void)
}

extension RepositoryProtocol {

  func fetch(sort: [NSSortDescriptor], completion: @escaping (Result<[EntityType], Error>) -> Void) {
    fetch(predicate: nil, sort: sort, completion: completion)
  }
}
