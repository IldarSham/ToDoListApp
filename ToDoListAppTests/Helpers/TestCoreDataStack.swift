//
//  TestCoreDataStack.swift
//  ToDoListAppTests
//
//  Created by Ildar Shamsullin on 10.08.2025.
//

import CoreData

class TestCoreDataStack {
  static let instance = TestCoreDataStack()
  
  let persistentContainer: NSPersistentContainer
  
  init() {
    persistentContainer = NSPersistentContainer(name: "ToDoListApp")
    
    let description = NSPersistentStoreDescription()
    description.type = NSInMemoryStoreType
    
    persistentContainer.persistentStoreDescriptions = [description]
    persistentContainer.loadPersistentStores { _, error in
      if let error = error as NSError? {
        fatalError("Unresolved error \(error), \(error.userInfo)")
      }
    }
  }
  
  var context: NSManagedObjectContext {
    return persistentContainer.viewContext
  }
}
