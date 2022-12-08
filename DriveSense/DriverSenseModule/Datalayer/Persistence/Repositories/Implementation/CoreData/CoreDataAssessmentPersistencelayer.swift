//
//  CoreDataAssessmentPersistenceLayer.swift
//  DriveSense
//
//  Created by Arpit Singh on 06/09/22.
//
import Combine
import Foundation
import CoreData
class CoreDataAssessmentPersistencelayer: AssessmentPersistenceLayer {

    // MARK: - properties
    
    var candidate: CandidatesModel
    private let repositories: DataHelperProtocol
    private let contextManager: PersistentStoreCoordinator
    
    // MARK: - methods
    
    init(candidate: CandidatesModel) {
        self.candidate = candidate
        repositories = CoreDataRepository()
        contextManager = PersistentStoreCoordinator(completion: { _ in
            
        })
    }
    
    func create(assessment: AssessmentModel) -> AnyPublisher<AssessmentModel, Error> {
        let context = contextManager.getBackgroundContext()
        let condition = NSPredicate(format: "id == %@",
                                    candidate.id.uuidString)
        return Publishers.Zip(repositories.fetch(type: CandidatesEntity.self,
                                                 predicate: condition,
                                                 sortDescriptors: nil, relationshipKeysToFetch: nil,
                                                 managedObjectContext: context),
                              repositories.create(type: AssessmentEntity.self, managedObjectContext: context))
            .tryMap { candidates, object -> AssessmentModel in
                object.intoObject(from: assessment, context: context)
                candidates.first?.addToAssessment(object)
                candidates.first?.instructor.addToAssessment(object)
                try context.save()
                return object.toDomainModel()
            }.eraseToAnyPublisher()
    }
    
    
    func createBatch(assessments: [AssessmentModel]) -> AnyPublisher<[AssessmentModel], Error> {
        let context = contextManager.getBackgroundContext()
        let condition = NSPredicate(format: "id == %@",
                                    candidate.id.uuidString)
        return Publishers.Zip(repositories
            .fetch(type: CandidatesEntity.self,
                   predicate: condition,
                   sortDescriptors: nil, relationshipKeysToFetch: nil,
                   managedObjectContext: context),
            repositories.batchCreate(type: AssessmentEntity.self,
                                     size: assessments.count,
                                     mangedObjectContext: context))
            .map { candidates, objects -> [AssessmentEntity] in
                for (assessmentModel, object) in zip(assessments, objects) {
                    object.intoObject(from: assessmentModel, context: context)
                    candidates.first?.addToAssessment(object)
                    candidates.first?.instructor.addToAssessment(object)
                }
                return objects
            }
            .tryMap { objects in
                try context.save()
                return objects.map { $0.toDomainModel() }
            }
            .eraseToAnyPublisher()
    }
    
    func update(assessment: AssessmentModel) -> AnyPublisher<AssessmentModel, Error> {
        let context = contextManager.getBackgroundContext()
        let condition = NSPredicate(format: "id == %@",assessment.id.uuidString)
        return repositories.update(type: AssessmentEntity.self,
                                   predicate: condition,
                                   managedObjectContext: context)
        .tryMap({ object in
            object.intoObject(from: assessment, context: context)
            try context.save()
            return object.toDomainModel()
        }).eraseToAnyPublisher()
    }
    
    func find(predicated: NSPredicate) -> AnyPublisher<AssessmentModel?, Error> {
        let context = contextManager.getBackgroundContext()
        return repositories.fetch(type: AssessmentEntity.self, predicate: predicated,
                                  sortDescriptors: [NSSortDescriptor(key: "createdAt",
                                                                     ascending: true)],
                                  relationshipKeysToFetch: nil,
                                  managedObjectContext: context)
        .map { objects in
            objects.first?.toDomainModel()
        }.eraseToAnyPublisher()
    }
    
    func fetch(page: Int, limit: Int, id: UUID?) -> AnyPublisher<[AssessmentModel], Error> {
        let context = contextManager.getBackgroundContext()
        if id != nil {
            let condition = NSPredicate(format: "id == %@", id?.uuidString ?? "")
            return repositories.fetch(type: AssessmentEntity.self, predicate: condition, sortDescriptors: [NSSortDescriptor(key: "createdAt",ascending: true)],
                relationshipKeysToFetch: nil, managedObjectContext: context).map { object in
                object.map { $0.toDomainModel() }
            }.eraseToAnyPublisher()
        } else {
            let fetchCondition = NSPredicate(format: "forCandidate.id == %@", candidate.id.uuidString)
            let offset = limit * (page < 0 ? 0 : page - 1)
            return repositories.fetch(type: AssessmentEntity.self,
                                      predicate: fetchCondition,
                                      sortDescriptors: [NSSortDescriptor(key: "createdAt",
                                                                         ascending: true)],
                                      relationshipKeysToFetch: ["forCandidate","feedback"],
                                      managedObjectContext: context,
                                      limit: limit, offset: offset)
                .map { objects -> [AssessmentModel] in
                    objects.map { $0.toDomainModel() }
                }.eraseToAnyPublisher()
        }
    }
    
    func remove(assessment: AssessmentModel) -> AnyPublisher<Void, Error> {
        let condition = NSPredicate(format: "id == %@", assessment.id.uuidString)
        let context = contextManager.getBackgroundContext()
        return repositories.delete(type: AssessmentEntity.self,
                                   predicate: condition,
                                   managedObjectContext: context)
    }
    
    func count() -> AnyPublisher<Int, Error> {
        let condition = NSPredicate(format: "forCandidate.id == %@",
                                    candidate.id.uuidString)
        let context = contextManager.getBackgroundContext()
        guard let attribute = NSEntityDescription.entity(forEntityName: "AssessmentEntity",
                                                         in: context)?
            .attributesByName.values.first(where: { $0.name == "id" })
        else {
            return Fail(error: CoreDataError.objectNotFound).eraseToAnyPublisher()
        }
        return repositories.fetchCount(type: AssessmentEntity.self, predicate: condition, relationshipKeysToFetch: ["forCandidate"], attribute: attribute,
                                       managedObjectContext: context)
    }
}
