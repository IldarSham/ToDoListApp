//
//  Persist.swift
//  ToDoListApp
//
//  Created by Ildar Shamsullin on 08.08.2025.
//

import Foundation

@propertyWrapper
struct Persist<T> {
  let key: String
  let defaultValue: T
  
  var wrappedValue: T {
    get { UserDefaults.standard.object(forKey: key) as? T ?? defaultValue }
    set { UserDefaults.standard.set(newValue, forKey: key) }
  }
}
