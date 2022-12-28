//
//  CoreDataRepository.swift
//  DriveSense
//
//  Created by Arpit Singh on 01/09/22.
//
import Combine
import CoreData
import Foundation
enum CoreDataError: Error {
    case invalidManagedObjectType
    case objectNotFound
    case invalidFetchRequest
}
class CoreDataRepository: DataHelperProtocol {

    init() {}
    
    func create<T>(type: T.Type,managedObjectContext mangedObjectContext: NSManagedObjectContext) -> AnyPublisher<T, Error> where T : NSManagedObject {
        return Future { promise in
        let className = String(describing: T.self)
        if let object = NSEntityDescription.insertNewObject(forEntityName: className, into: mangedObjectContext) as? T {
            promise(.success(object))
        } else {
            promise(.failure(CoreDataError.invalidManagedObjectType))
        }
      }.eraseToAnyPublisher()
    }
    
    func batchCreate<T>(type: T.Type,size: Int, mangedObjectContext: NSManagedObjectContext) -> AnyPublisher<[T], Error> where T : NSManagedObject {
        let publisher = create(type: type,managedObjectContext: mangedObjectContext)
        if size > 1 {
        return (1..<size).reduce(publisher) { partialResult, _ in
            let newPublisher = create(type: type, managedObjectContext: mangedObjectContext)
            return partialResult.merge(with: newPublisher).eraseToAnyPublisher()
        }.collect(size).eraseToAnyPublisher()
       } else {
           return publisher.collect(size).eraseToAnyPublisher()
       }
    }
    
    fileprivate func requestBuilder<T>(type: T.Type, predicate: NSPredicate?, sortDescriptors: [NSSortDescriptor]? = nil, relationshipKeysToFetch: [String]? = nil) -> NSFetchRequest<NSFetchRequestResult> {
        let className = String(describing: T.self)
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: className)
        if let predicate = predicate {
            request.predicate = predicate
        }
        if let sortDescriptors = sortDescriptors {
             request.sortDescriptors = sortDescriptors
        }
          
        if let relationshipKeysToFetch = relationshipKeysToFetch {
              request.relationshipKeyPathsForPrefetching = relationshipKeysToFetch
        }
        return request
    }
    
    func fetch<T>(type: T.Type, predicate: NSPredicate?, sortDescriptors: [NSSortDescriptor]?, relationshipKeysToFetch: [String]?, managedObjectContext: NSManagedObjectContext, limit: Int, offset: Int) -> AnyPublisher<[T], Error> where T : NSManagedObject {
        let request = requestBuilder(type: type, predicate: predicate,
                                   sortDescriptors: sortDescriptors,
                                   relationshipKeysToFetch: relationshipKeysToFetch)
        return Future { promise in
          managedObjectContext.perform {
            if limit != 0 {
                request.fetchLimit = limit
                request.fetchOffset = offset
            }
            do {
                if let result = try managedObjectContext.fetch(request) as? [T] {
                    promise(.success(result))
                } else {
                    promise(.failure(CoreDataError.invalidManagedObjectType))
                }
              } catch {
                 promise(.failure(CoreDataError.invalidFetchRequest))
             }
          }
      }.eraseToAnyPublisher()
    }
    
    func fetch<T>(type: T.Type, predicate: NSPredicate?, sortDescriptors: [NSSortDescriptor]?, relationshipKeysToFetch: [String]?, managedObjectContext: NSManagedObjectContext) -> AnyPublisher<[T], Error> where T : NSManagedObject {
        return fetch(type: type, predicate: predicate, sortDescriptors: sortDescriptors,
                     relationshipKeysToFetch: relationshipKeysToFetch,
                     managedObjectContext: managedObjectContext, limit: 0, offset: 0)
    }
        
    func delete<T>(type: T.Type, predicate: NSPredicate, managedObjectContext: NSManagedObjectContext) -> AnyPublisher<Void, Error> where T : NSManagedObject {
        return fetch(type: type, predicate: predicate,sortDescriptors: nil,
                     relationshipKeysToFetch: nil
                     ,managedObjectContext: managedObjectContext)
               .tryMap { values in
                   values.forEach { value in
                      managedObjectContext.delete(value)
                   }
                   if managedObjectContext.hasChanges {
                       try managedObjectContext.save()
                   }
               }.eraseToAnyPublisher()
    }

    func saveIfNeed(context: NSManagedObjectContext) throws {
        if context.hasChanges {
            try context.save()
        }
    }
}

extension CoreDataRepository {
        
    private func createRequest<T>(type: T.Type,predicate: NSPredicate?,
                               relation: [String]? = nil,
                               attribute: NSAttributeDescription,
                               groupBy: NSAttributeDescription?,
                               function: CoreDataFunction,
                               managedObjectContext: NSManagedObjectContext) ->  NSFetchRequest<NSFetchRequestResult> where T : NSManagedObject{
        let request = requestBuilder(type: type, predicate: predicate, sortDescriptors: nil, relationshipKeysToFetch: relation)
        if let groupBy = groupBy {
            request.propertiesToGroupBy = [groupBy]
        }
        let function = function
        request.resultType = .dictionaryResultType
        let expression = NSExpressionDescription.generate(function: function, col: attribute)
        request.propertiesToFetch = [expression]
        return request
    }
    
    fileprivate func aggregate<V>(function: CoreDataFunction,
                                  request: NSFetchRequest<NSFetchRequestResult>,
                                  context: NSManagedObjectContext) -> AnyPublisher<V,Error> where V : Numeric {
       return Future { promise in
              context.perform {
                do {
                   let fetched =  try context
                        .fetch(request)
                    print(fetched)
                    if let result = fetched as? [[String : Any]],
                       let resultValue = result.first?.values.first as? V {
                        promise(.success(resultValue))
                    } else {
                        promise(.failure(CoreDataError.invalidManagedObjectType))
                    }
                } catch {
                    promise(.failure(CoreDataError.invalidFetchRequest))
                }
            }
        }.eraseToAnyPublisher()
    }
    
    
    func fetchSum<T>(type: T.Type, predicate: NSPredicate?,
                     attribute: NSAttributeDescription,
                     relationshipKeysToFetch: [String]?,
                     groupBy: NSAttributeDescription?,
                     managedObjectContext: NSManagedObjectContext) -> AnyPublisher<Double, Error> where T : NSManagedObject {
        
        let function = CoreDataFunction.sum
        let request = createRequest(type: type, predicate: predicate,relation: relationshipKeysToFetch
                                    ,attribute: attribute,
                                    groupBy: groupBy, function: function,
                                    managedObjectContext: managedObjectContext)
        return aggregate(function: function, request: request,
                         context: managedObjectContext)
    }
    
    func fetchCount<T>(type: T.Type, predicate: NSPredicate?,
                       relationshipKeysToFetch: [String]?,
                       attribute: NSAttributeDescription,
                       managedObjectContext: NSManagedObjectContext) -> AnyPublisher<Int, Error> where T : NSManagedObject {
        let request = requestBuilder(type: type, predicate: predicate, sortDescriptors: nil,relationshipKeysToFetch: relationshipKeysToFetch)
        return Future { promise in
            managedObjectContext.perform {
                do {
                    let result = try managedObjectContext.count(for: request)
                    promise(.success(result))
                } catch {
                    promise(.failure(CoreDataError.objectNotFound))
                }
            }
        }.eraseToAnyPublisher()
    }
    func fetchAverage<T>(type: T.Type, predicate: NSPredicate?,
                         attribute: NSAttributeDescription,
                         relationshipKeysToFetch: [String]?,
                         groupBy: NSAttributeDescription?,
                         managedObjectContext: NSManagedObjectContext) -> AnyPublisher<Double, Error> where T : NSManagedObject {
        let function = CoreDataFunction.average
        let request = createRequest(type: type, predicate: predicate,
                                    relation: relationshipKeysToFetch,
                                    attribute: attribute,
                                    groupBy: groupBy, function: function,
                                    managedObjectContext: managedObjectContext)
        return aggregate(function: function, request: request,
                         context: managedObjectContext)
    }
    
    func update<T>(type: T.Type, predicate: NSPredicate,managedObjectContext: NSManagedObjectContext) -> AnyPublisher<T, Error> where T : NSManagedObject {
        return fetch(type: type, predicate: predicate, sortDescriptors: nil, relationshipKeysToFetch: nil, managedObjectContext: managedObjectContext)
            .tryMap({ values in
                if let object = values.first {
                    return object
                } else {
                    throw CoreDataError.objectNotFound
                }
            })
            .eraseToAnyPublisher()
    }
    
}
