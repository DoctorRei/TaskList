//
//  StorageManager.swift
//  TaskList
//
//  Created by Акира on 29.08.2023.
//

import CoreData

class StorageManager {
    
    static var shared = StorageManager()
    
    private let viewContext: NSManagedObjectContext
    
    private let persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Track")
        container.loadPersistentStores { _, error in
            if let error = error as? NSError {
                fatalError(error.localizedDescription)
            }
        }
        return container
    }()
    
    
    private init () {
        viewContext = persistentContainer.viewContext
    }
    
    
}
