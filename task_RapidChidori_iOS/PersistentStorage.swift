//
//  PersistentStorage.swift
//  task_RapidChidori_iOS
//
//  Created by Rohit Sharma on 23/01/22.
//

import Foundation
import CoreData

final class PersistentStorage {
    
    private init() {}
    static let shared = PersistentStorage()
    
    // MARK: - Core Data
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "task_RapidChidori_iOS")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
                if let error = error as NSError? {
                    fatalError("Unresolved error \(error), \(error.userInfo)")
                }
            })
            return container
        }()
        
    lazy var context = persistentContainer.viewContext

        // MARK: - Core Data Saving support
        
        func saveContext () {
            if context.hasChanges {
                do {
                    try context.save()
                } catch {
                    let nserror = error as NSError
                    fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
                }
            }
        }
}

