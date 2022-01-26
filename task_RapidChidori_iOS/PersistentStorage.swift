//
//  PersistentStorage.swift
//  task_RapidChidori_iOS
//
//  Created by Shubham Behal on 23/01/22.
//

import Foundation
import CoreData


//this is the singleton class of core data to keep data persistant through multiple sessions of app
final class PersistentStorage {
    
    private init() {}
    static let shared = PersistentStorage()
    
//core data
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

       
//saving core data 
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

