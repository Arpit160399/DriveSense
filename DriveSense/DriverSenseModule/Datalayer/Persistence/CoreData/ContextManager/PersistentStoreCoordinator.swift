//
//  CoreDataContextProvider.swift
//  DriveSense
//
//  Created by Arpit Singh on 01/09/22.
//
import CoreData
import Foundation
class PersistentStoreCoordinator {
    
    // MARK: - Properties
    
    /// Main Managed Object Context used by UI Components only
    var viewContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    private var persistentContainer: NSPersistentContainer
    
    // MARK: - Methods
    init(completion: @escaping (Error?) -> Void )  {
        persistentContainer = NSPersistentContainer(name: "localDB")
        persistentContainer.loadPersistentStores { _, error in
            completion(error)
        }
        print(persistentContainer.persistentStoreDescriptions.first?.url as Any)
    }
    
    /// Worker Managed Object Context Used for heavy task to prevent blocking of main thread
    func getBackgroundContext() -> NSManagedObjectContext {
     let backgroundContext = persistentContainer
                             .newBackgroundContext()
     return backgroundContext
    }
    
}
