//
//  DataHelperProtocol.swift
//  DriveSense
//
//  Created by Arpit Singh on 02/09/22.
//
import Combine
import CoreData
import Foundation
protocol DataHelperProtocol {
    func create<T: NSManagedObject>(type: T.Type,
                                    managedObjectContext: NSManagedObjectContext) -> AnyPublisher<T, Error>
    
    func batchCreate<T: NSManagedObject>(type: T.Type, size: Int,
                                         mangedObjectContext: NSManagedObjectContext) -> AnyPublisher<[T], Error>
    
    func fetch<T: NSManagedObject>(type: T.Type, predicate: NSPredicate?,
                                   sortDescriptors: [NSSortDescriptor]?,
                                   relationshipKeysToFetch: [String]?,
                                   managedObjectContext: NSManagedObjectContext, limit: Int,
                                   offset: Int) -> AnyPublisher<[T], Error>
    
    func fetch<T: NSManagedObject>(type: T.Type, predicate: NSPredicate?,
                                   sortDescriptors: [NSSortDescriptor]?,
                                   relationshipKeysToFetch: [String]?,
                                   managedObjectContext: NSManagedObjectContext) -> AnyPublisher<[T], Error>
    
    func fetchCount<T: NSManagedObject>(type: T.Type, predicate: NSPredicate?,
                                        relationshipKeysToFetch: [String]?,
                                        attribute: NSAttributeDescription,
                                        managedObjectContext: NSManagedObjectContext) -> AnyPublisher<Int, Error>
    func fetchSum<T: NSManagedObject>(type: T.Type, predicate: NSPredicate?,
                                      attribute: NSAttributeDescription,
                                      relationshipKeysToFetch: [String]?,
                                      groupBy: NSAttributeDescription?,
                                      managedObjectContext: NSManagedObjectContext) -> AnyPublisher<Double, Error>
    func fetchAverage<T: NSManagedObject>(type: T.Type, predicate: NSPredicate?,
                                          attribute: NSAttributeDescription,
                                          relationshipKeysToFetch: [String]?,
                                          groupBy: NSAttributeDescription?,
                                          managedObjectContext: NSManagedObjectContext) -> AnyPublisher<Double, Error>
    
    func update<T: NSManagedObject>(type: T.Type, predicate: NSPredicate, managedObjectContext: NSManagedObjectContext) -> AnyPublisher<T, Error>

    func delete<T: NSManagedObject>(type: T.Type,
                                    predicate: NSPredicate,
                                    managedObjectContext: NSManagedObjectContext) -> AnyPublisher<Void, Error>
    func saveIfNeed(context: NSManagedObjectContext) throws 
}
