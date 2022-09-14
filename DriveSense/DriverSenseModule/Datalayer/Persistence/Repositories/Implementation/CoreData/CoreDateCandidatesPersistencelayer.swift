//
//  CoreDateCandidatesPersistenceLayer.swift
//  DriveSense
//
//  Created by Arpit Singh on 03/09/22.
//
import Combine
import CoreData
import Foundation
class CoreDataCandidatesPersistenceLayer: CandidatePersistenceLayer {
    
    // MARK: - properties
    
    var instructor: InstructorModel
    private let contextManager: PersistentStoreCoordinator
    private let repositories: DataHelperProtocol
    
    // MARK: - method
    
    init(instructor: InstructorModel) {
        self.instructor = instructor
        contextManager = PersistentStoreCoordinator(completion: { _ in
            
        })
        repositories = CoreDataRepository()
    }
    
    func create(candidate: CandidatesModel) -> AnyPublisher<CandidatesModel, Error> {
        let context = contextManager.getBackgroundContext()
        let condition = NSPredicate(format: "id == %@", instructor.id.uuidString)
        
        return Publishers.Zip(repositories.fetch(type: InstructorEntity.self,
                                                 predicate: condition,
                                                 sortDescriptors: nil, relationshipKeysToFetch: nil,
                                                 managedObjectContext: context),
                              repositories.create(type: CandidatesEntity.self,
                                                  managedObjectContext: context))
            .tryMap { (instructors: [InstructorEntity], object: CandidatesEntity) in
                object.intoObject(from: candidate, context: context)
                instructors.first?.addToStudents(object)
                return object
            }.tryMap { (object: CandidatesEntity) -> CandidatesModel in
                try context.save()
                return object.toDomainModel()
            }
            .eraseToAnyPublisher()
    }
    
    func batchCreate(candidates: [CandidatesModel]) -> AnyPublisher<[CandidatesModel], Error> {
        let context = contextManager.getBackgroundContext()
        let condition = NSPredicate(format: "id == %@", instructor.id.uuidString)
        
        return Publishers.Zip(repositories.fetch(type: InstructorEntity.self,
                                                 predicate: condition,
                                                 sortDescriptors: nil, relationshipKeysToFetch: nil,
                                                 managedObjectContext: context),
                              repositories.batchCreate(type: CandidatesEntity.self,
                                                       size: candidates.count, mangedObjectContext: context))
            .tryMap { instructors, candidatesEntity -> [CandidatesEntity] in
                var collection = [CandidatesEntity]()
                for (index, candidate) in zip(0 ..< candidates.count, candidates) {
                    candidatesEntity[index].intoObject(from: candidate,
                                                       context: context)
                    instructors.first?.addToStudents(candidatesEntity[index])
                    collection.append(candidatesEntity[index])
                }
                return collection
            }.tryMap { (candidatesOb: [CandidatesEntity]) in
                try context.save()
                return candidatesOb.map { $0.toDomainModel() }
            }
            .eraseToAnyPublisher()
    }
    
    func remove(candidate: CandidatesModel) -> AnyPublisher<Void, Error> {
        let context = contextManager.getBackgroundContext()
        let condition = NSPredicate(format: "id == %@", instructor.id.uuidString)
        return repositories.delete(type: CandidatesEntity.self,
                                   predicate: condition,
                                   managedObjectContext: context)
            .eraseToAnyPublisher()
    }
    
    func fetch(page: Int, limit: Int, id: UUID?) -> AnyPublisher<[CandidatesModel], Error> {
        let context = contextManager.getBackgroundContext()
        if id != nil {
            let condition = NSPredicate(format: "id == %@", id?.uuidString ?? "")
            return repositories.fetch(type: CandidatesEntity.self, predicate: condition, sortDescriptors: nil, relationshipKeysToFetch: nil, managedObjectContext: context).map { object in
                object.map { $0.toDomainModel() }
            }.eraseToAnyPublisher()
        } else {
            let fetchCondition = NSPredicate(format: "instructor.id == %@", instructor.id.uuidString)
            let offset = limit * (page < 0 ? 0 : page - 1)
            return repositories.fetch(type: CandidatesEntity.self,
                                      predicate: fetchCondition,
                                      sortDescriptors: nil,
                                      relationshipKeysToFetch: ["instructor"],
                                      managedObjectContext: context,
                                      limit: limit, offset: offset)
                .map { objects -> [CandidatesModel] in
                    objects.map { $0.toDomainModel() }
                }.eraseToAnyPublisher()
        }
    }
    
    func count() -> AnyPublisher<Int, Error> {
        let condition = NSPredicate(format: "instructor.id == %@", instructor.id.uuidString)
        let context = contextManager.getBackgroundContext()
        let entity = NSEntityDescription
            .entity(forEntityName: "CandidatesEntity", in: context)
        guard let attribute = entity?.attributesByName["name"] else {
            return Fail(error: CoreDataError.objectNotFound).eraseToAnyPublisher()
        }
        return repositories.fetchCount(type: CandidatesEntity.self,
                                       predicate: condition,
                                       relationshipKeysToFetch: ["instructor"],
                                       attribute: attribute,
                                       managedObjectContext: context)
    }
}
