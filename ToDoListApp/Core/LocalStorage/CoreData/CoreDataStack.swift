//
//  CoreDataStack.swift
//  ToDoListApp
//
//  Created by Ildar Shamsullin on 06.08.2025.
//

import CoreData

final class CoreDataStack {
  let container: NSPersistentContainer
  
  var viewContext: NSManagedObjectContext { container.viewContext }
  
  public init() {
    container = NSPersistentContainer(name: "ToDoListApp")
    container.loadPersistentStores { _, error in
      if let error = error {
        fatalError("Core Data load error: \(error)")
      }
    }
    viewContext.automaticallyMergesChangesFromParent = true
  }
  
  func performBackground(_ block: @escaping (NSManagedObjectContext) -> Void) {
    container.performBackgroundTask(block)
  }
}
