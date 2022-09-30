//
//  CoreDataInstructorPersistencelayer.swift
//  DriveSense
//
//  Created by Arpit Singh on 06/09/22.
//
import Combine
import Foundation
class CoreDataInstructorPersistencelayer: InstructorPersistenceLayer {
 
    //MARK: - properties
    
    private var repositories: DataHelperProtocol
    private let contextManager: PersistentStoreCoordinator
    
    //MARK: - methods 
    
    init() {
        repositories = CoreDataRepository()
        contextManager = PersistentStoreCoordinator(completion: { error in
            
        })
    }
    
    func create(instructor: InstructorModel) -> AnyPublisher<InstructorModel, Error> {
        let context = contextManager.getBackgroundContext()
        return repositories.create(type: InstructorEntity.self, managedObjectContext: context)
            .tryMap { object in
                object.intoObject(from: instructor, context: context)
                try context.save()
                return object.toDomainModel()
            }.eraseToAnyPublisher()
    }
    
    func update(instructor: InstructorModel) -> AnyPublisher<InstructorModel, Error> {
        let context = contextManager.getBackgroundContext()
        let condition = NSPredicate(format: "id == %@",
                                    instructor.id.uuidString)
        let relation = ["adi"]
        return repositories.fetch(type: InstructorEntity.self,
                                  predicate: condition,
                                  sortDescriptors: nil,
                                  relationshipKeysToFetch: relation,
                                  managedObjectContext: context)
        .tryMap { (objects) -> InstructorModel in
            guard let object = objects.first else {
                throw CoreDataError.objectNotFound
            }
            object.intoObject(from: instructor, context: context)
            try context.save()
            return object.toDomainModel()
        }.eraseToAnyPublisher()
    }
    
    func find(predicated: NSPredicate) -> AnyPublisher<InstructorModel?, Error> {
        let context = contextManager.getBackgroundContext()
        return repositories.fetch(type: InstructorEntity.self, predicate: predicated,
                                  sortDescriptors: [NSSortDescriptor(key: "createdAt",
                                                                     ascending: true)],
                                  relationshipKeysToFetch: ["adi"],
                                  managedObjectContext: context)
        .map { objects in
            objects.first?.toDomainModel()
        }.eraseToAnyPublisher()
    }
    
    func fetch(id: UUID) -> AnyPublisher<InstructorModel, Error> {
        let context = contextManager.getBackgroundContext()
        let condition = NSPredicate(format: "id == %@", id.uuidString)
        return repositories.fetch(type: InstructorEntity.self, predicate: condition, sortDescriptors: nil,
            relationshipKeysToFetch: ["adi"],
            managedObjectContext: context)
            .tryMap({ (objects) -> InstructorModel in
                if let instructor = objects.first {
                    return instructor.toDomainModel()
                } else {
                    throw CoreDataError.objectNotFound
                }
            }).eraseToAnyPublisher()
    }
    
    func remove(instructor: InstructorModel) -> AnyPublisher<Void, Error> {
        let context = contextManager.getBackgroundContext()
        let condition = NSPredicate(format: " id == %@", instructor.id.uuidString)
        return repositories.delete(type: InstructorEntity.self,
                predicate: condition,
                managedObjectContext: context)
    }
}
