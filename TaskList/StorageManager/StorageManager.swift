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
        let container = NSPersistentContainer(name: "TaskList")
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
    
    func fetchData(completion: (Result<[Task], Error>) -> Void) {
        let fetchRequest = Task.fetchRequest()
        
        do {
            let tasks = try viewContext.fetch(fetchRequest)
            completion(.success(tasks))
        } catch let error {
            completion(.failure(error))
        }
    }
    
    // Work with dataStore
    
    func create (_ taskName: String, completion: (Task) -> Void) {
        let task = Task(context: viewContext)
        task.title = taskName
        completion(task)
        save()
    }
    
    
    func edditing(_ task: Task, newValue: String) {
        task.title = newValue
        save()
    }
    
    func delete(that task: Task) {
        viewContext.delete(task)
        save()
    }
    
    func save() {
        if viewContext.hasChanges {
            do {
                try viewContext.save()
            } catch {
                let error = error as NSError
                fatalError(error.localizedDescription)
            }
        }
    }
    
}
