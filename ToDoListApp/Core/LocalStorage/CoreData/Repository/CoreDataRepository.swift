//
//  CoreDataRepository.swift
//  ToDoListApp
//
//  Created by Ildar Shamsullin on 06.08.2025.
//

import CoreData

enum CoreDataError: Error {
  case invalidManagedObjectType
  case objectNotFound
}

final class CoreDataRepository<T: NSManagedObject> {
  private let stack: CoreDataStack
  private let entityName: String
  
  init(stack: CoreDataStack, entityName: String? = nil) {
    self.stack = stack
    self.entityName = entityName ?? String(describing: T.self)
  }
  
  // MARK: - CRUD
  
  func create(configure: @escaping (T) -> Void, completion: @escaping (Result<T, Error>) -> Void) {
    stack.performBackground { ctx in
      guard let entity = NSEntityDescription.insertNewObject(forEntityName: self.entityName, into: ctx) as? T else {
        self.completeOnMain(.failure(CoreDataError.invalidManagedObjectType), completion)
        return
      }
      configure(entity)
      self.saveAndComplete(on: ctx, object: entity, completion: completion)
    }
  }
  
  func createBatch<U>(
    items: [U],
    configure: @escaping (T, U) -> Void,
    completion: @escaping (Result<[T], Error>) -> Void
  ) {
    guard !items.isEmpty else {
       completion(.success([]))
       return
     }
     
     stack.performBackground { ctx in
       var createdObjects: [T] = []
       
       do {
         for item in items {
           guard let entity = NSEntityDescription.insertNewObject(forEntityName: self.entityName, into: ctx) as? T else {
             throw CoreDataError.invalidManagedObjectType
           }
           
           configure(entity, item)
           createdObjects.append(entity)
         }
         
         if ctx.hasChanges {
           try ctx.save()
         }
         
         let objectIDs = createdObjects.map { $0.objectID }
         DispatchQueue.main.async {
           let mainContext = self.stack.viewContext
           let mainObjects = objectIDs.compactMap { mainContext.object(with: $0) as? T }
           completion(.success(mainObjects))
         }
       } catch {
         self.completeOnMain(.failure(error), completion)
       }
     }
   }
  
  func update(object: T, changes: @escaping (T) -> Void, completion: @escaping (Result<T, Error>) -> Void) {
    let objectID = object.objectID
    stack.performBackground { ctx in
      guard let localObject = ctx.object(with: objectID) as? T else {
        self.completeOnMain(.failure(CoreDataError.objectNotFound), completion)
        return
      }
      changes(localObject)
      self.saveAndComplete(on: ctx, object: localObject, completion: completion)
    }
  }
  
  func delete(object: T, completion: @escaping (Result<Void, Error>) -> Void) {
    let objectID = object.objectID
    stack.performBackground { ctx in
      do {
        let objectToDelete = try ctx.existingObject(with: objectID)
        ctx.delete(objectToDelete)
        try ctx.save()
        self.completeOnMain(.success(()), completion)
      } catch {
        self.completeOnMain(.failure(error), completion)
      }
    }
  }
  
  // MARK: - Fetch
  
  func fetch(predicate: NSPredicate? = nil, sort: [NSSortDescriptor] = [], completion: @escaping (Result<[T], Error>) -> Void) {
    stack.performBackground { ctx in
      let request = NSFetchRequest<T>(entityName: self.entityName)
      request.predicate = predicate
      request.sortDescriptors = sort
      request.returnsObjectsAsFaults = false
      
      do {
        let backgroundObjects = try ctx.fetch(request)
        let objectIDs = backgroundObjects.map { $0.objectID }
        
        DispatchQueue.main.async {
          let mainContext = self.stack.viewContext
          let mainObjects = objectIDs.compactMap { mainContext.object(with: $0) as? T }
          completion(.success(mainObjects))
        }
      } catch {
        self.completeOnMain(.failure(error), completion)
      }
    }
  }
  
  // MARK: - Helpers
  
  private func saveAndComplete(on ctx: NSManagedObjectContext, object: T, completion: @escaping (Result<T, Error>) -> Void) {
    do {
      if ctx.hasChanges {
        try ctx.save()
      }
      let objectID = object.objectID
      completeOnMain(with: objectID, completion: completion)
    } catch {
      completeOnMain(.failure(error), completion)
    }
  }
  
  private func completeOnMain<U>(_ result: Result<U, Error>, _ completion: @escaping (Result<U, Error>) -> Void) {
    DispatchQueue.main.async {
      completion(result)
    }
  }
  
  private func completeOnMain(with objectID: NSManagedObjectID, completion: @escaping (Result<T, Error>) -> Void) {
    DispatchQueue.main.async {
      let mainObject = self.stack.viewContext.object(with: objectID) as? T
      
      if let mainObject = mainObject {
        completion(.success(mainObject))
      } else {
        completion(.failure(CoreDataError.objectNotFound))
      }
    }
  }
}
