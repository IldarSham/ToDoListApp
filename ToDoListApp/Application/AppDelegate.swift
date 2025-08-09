//
//  AppDelegate.swift
//  ToDoListApp
//
//  Created by Ildar Shamsullin on 04.08.2025.
//

import UIKit
import CoreData

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
  
  let injectionContainer = AppDependencyContainer()
  var window: UIWindow?
  
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    let navigationController = UINavigationController()

    window = UIWindow()
    window?.rootViewController = navigationController
    
    let router = StartRouter(navigationController: navigationController,
                             taskListViewControllerFactory: injectionContainer)
    let viewController = injectionContainer.makeStartViewController(router: router)
    navigationController.pushViewController(viewController, animated: true)
    
    window?.makeKeyAndVisible()
    
    return true
  }
}
