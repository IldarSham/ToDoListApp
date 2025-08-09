//
//  Todo+CoreDataClass.swift
//  ToDoListApp
//
//  Created by Ildar Shamsullin on 06.08.2025.
//
//

import Foundation
import CoreData

@objc(Todo)
public class Todo: NSManagedObject {

}

extension Todo {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Todo> {
        return NSFetchRequest<Todo>(entityName: "Todo")
    }

    @NSManaged public var title: String
    @NSManaged public var content: String?
    @NSManaged public var date: Date
    @NSManaged public var isCompleted: Bool

}

extension Todo : Identifiable {

}
