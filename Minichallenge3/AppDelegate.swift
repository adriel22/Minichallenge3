//
//  AppDelegate.swift
//  Minichallenge3
//
//  Created by Adriel Freire on 06/05/19.
//  Copyright © 2019 Adriel Freire. All rights reserved.
//

import UIKit
import CoreData
import HistoryGraph
// swiftlint:disable all
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
//        let controller = MyNarrativesViewController()
//        window = UIWindow(frame: UIScreen.main.bounds)
//        window?.rootViewController = controller
//        window?.makeKeyAndVisible()

//        let statusBar: UIView = UIApplication.shared.value(forKey: "statusBar") as! UIView
//        if statusBar.responds(to:#selector(setter: UIView.backgroundColor)) {
//            statusBar.backgroundColor = UIColor(color: .darkBlue)
//        }
        
        UINavigationBar.appearance().barTintColor = UIColor(color: .darkBlue)
        UINavigationBar.appearance().tintColor = UIColor(color: .yellowWhite)
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor(color: .yellowWhite)]
        UINavigationBar.appearance().isTranslucent = false
        
        //        let controller = MyNarrativesViewController()
        //        window = UIWindow(frame: UIScreen.main.bounds)
        //        window?.rootViewController = controller
        //        window?.makeKeyAndVisible()
        
        let story = HistoryNode(withResume: "RESUME", text: "TEXT", positionX: 2, andPositionY: 0)
        let graph = HistoryGraph(withName: "Juremoids", sinopse: "blablabla", width: 3, andHeight: 3)
        try? graph.addNode(story)
        
        let controller = DetailsViewController()
        controller.viewModel = DetailsViewModel(story: story, graph: graph)
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = UINavigationController(rootViewController: controller)
        window?.makeKeyAndVisible()
        
        let statusBar: UIView = UIApplication.shared.value(forKey: "statusBar") as! UIView
        if statusBar.responds(to:#selector(setter: UIView.backgroundColor)) {
            statusBar.backgroundColor = UIColor(color: .darkBlue)
        }

        
        
        return true
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        self.saveContext()
    }

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "Minichallenge3")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}

