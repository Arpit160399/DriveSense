//
//  CoreDateSensorPersistencelayer.swift
//  DriveSense
//
//  Created by Arpit Singh on 06/09/22.
//
import Combine
import Foundation
import CoreData
class CoreDateSensorPersistencelayer: SensorPersistenceLayer {
    // MARK: - properties
    
    var assessment: AssessmentModel
    private let repositories: DataHelperProtocol
    private let contextManager: PersistentStoreCoordinator
    
    
    //MARK: - methods
    
    init(assessment: AssessmentModel) {
        self.assessment = assessment
        repositories = CoreDataRepository()
        contextManager = PersistentStoreCoordinator(completion: { error in
            
        })
    }

    func create(sensor: SensorModel) -> AnyPublisher<SensorModel, Error> {
        let context = contextManager.getBackgroundContext()
        let condition = NSPredicate(format: "id == %@", assessment.id.uuidString)
        return Publishers.Zip(repositories.fetch(type: AssessmentEntity.self,
                        predicate: condition, sortDescriptors: nil,
                        relationshipKeysToFetch: nil,
                        managedObjectContext: context),
                        repositories.create(type: SensorEntity.self,
                        managedObjectContext: context))
                    .map { (assessments,object) -> SensorEntity in
                        object.intoObject(from: sensor, context: context)
                        assessments.first?.addToSensor(object)
                        return object
                    }.tryMap { object -> SensorModel in
                       try context.save()
                       return object.toDomainModel()
                    }.eraseToAnyPublisher()
    }
    
    func find(predicated: NSPredicate) -> AnyPublisher<SensorModel?, Error> {
        let context = contextManager.getBackgroundContext()
        return repositories.fetch(type: SensorEntity.self, predicate: predicated,
                                  sortDescriptors: [NSSortDescriptor(key: "createdAt",
                                                                     ascending: true)],
                                  relationshipKeysToFetch: nil,
                                  managedObjectContext: context)
        .map { objects in
            objects.first?.toDomainModel()
        }.eraseToAnyPublisher()
    }
    
    func createBatch(sensors: [SensorModel]) -> AnyPublisher<[SensorModel], Error> {
        let content = contextManager.getBackgroundContext()
        let condition = NSPredicate(format: "id == %@", assessment.id.uuidString)
        return Publishers.Zip(repositories.fetch(type: AssessmentEntity.self,
                                                 predicate: condition,
                                                 sortDescriptors: nil,
                                                 relationshipKeysToFetch: nil,
                                                 managedObjectContext: content),
                              repositories.batchCreate(type: SensorEntity.self,
                              size: sensors.count,
                              mangedObjectContext: content))
        .tryMap { (assessments,objects) -> [SensorModel] in
            for (sensor,object) in zip(sensors, objects) {
                object.intoObject(from: sensor, context: content)
                assessments.first?.addToSensor(object)
            }
            try content.save()
            return objects.map({$0.toDomainModel()})
        }.eraseToAnyPublisher()
    }
    
    func update(feedback: FeedbackModel) -> AnyPublisher<FeedbackModel, Error> {
        let context = contextManager.getBackgroundContext()
        let condition = NSPredicate(format: "id == %@",
                                    feedback.id?.uuidString ?? "")
        let relation = ["control","judgement","junctions",
                        "moveOff","positioning","progress"]
        return repositories.fetch(type: FeedbackEntity.self,
                                  predicate: condition,
                                  sortDescriptors: nil,
                                  relationshipKeysToFetch: relation,
                                  managedObjectContext: context)
        .tryMap { (objects) -> FeedbackModel in
            guard let object = objects.first else {
                throw CoreDataError.objectNotFound
            }
            object.intoObject(from: feedback,
                                      context: context)
            try context.save()
            return object.toDomainModel()
        }.eraseToAnyPublisher()
    }
    
    func getAvgSpeed() -> AnyPublisher<Double, Error> {
        let condition = NSPredicate(format: "assessment.id == %@", assessment.id.uuidString)
        let context = contextManager.getBackgroundContext()
        guard let attribute = NSEntityDescription.entity(forEntityName: "SensorEntity",
                                                         in: context)?
            .attributesByName["speed"] else {
            return Fail(error: CoreDataError.objectNotFound)
                .eraseToAnyPublisher()
        }
        print(attribute)
        return repositories.fetchAverage(type: SensorEntity.self, predicate: condition,
               attribute: attribute, relationshipKeysToFetch: ["assessment"], groupBy: nil,
               managedObjectContext: context)
    }
    
    func getTotalDistance() -> AnyPublisher<Double, Error> {
        let condition = NSPredicate(format: "assessment.id == %@", assessment.id.uuidString)
        let context = contextManager.getBackgroundContext()
        guard let attribute = NSEntityDescription.entity(forEntityName: "SensorEntity",
                                                         in: context)?
            .attributesByName
            .values.first(where: { $0.name == "distance" }) else {
            return Fail(error: CoreDataError.objectNotFound)
                .eraseToAnyPublisher()
        }
        return repositories.fetchSum(type: SensorEntity.self, predicate: condition,
               attribute: attribute, relationshipKeysToFetch: ["assessment"], groupBy: nil,
               managedObjectContext: context)
    }
    
    func fetch(page: Int, limit: Int, id: UUID?) -> AnyPublisher<[SensorModel], Error> {
        let context = contextManager.getBackgroundContext()
        if id != nil {
            let condition = NSPredicate(format: "id == %@", id?.uuidString ?? "")
            return repositories.fetch(type: SensorEntity.self, predicate: condition,
                                      sortDescriptors: [NSSortDescriptor(key: "createdAt",
                                                                         ascending: true)],
                                      relationshipKeysToFetch: nil, managedObjectContext: context).map { object in
                  return object.map({ $0.toDomainModel() })
                 }.eraseToAnyPublisher()
        } else {
            let fetchCondition = NSPredicate(format: "assessment.id == %@", assessment.id.uuidString)
            let offset = limit * (page < 0 ? 0 : page - 1)
            return repositories.fetch(type: SensorEntity.self,
                            predicate: fetchCondition,
                            sortDescriptors: [NSSortDescriptor(key: "createdAt",
                                                               ascending: true)],
                            relationshipKeysToFetch: ["assessment"],
                            managedObjectContext: context,
                            limit: limit, offset: offset)
                      .map { objects -> [SensorModel] in
                          return objects.map({$0.toDomainModel()})
                      }.eraseToAnyPublisher()
        }
    }
    
    func count() -> AnyPublisher<Int, Error> {
        let condition = NSPredicate(format: "assessment.id == %@", assessment.id.uuidString)
        let context = contextManager.getBackgroundContext()
        guard let attribute = NSEntityDescription.entity(forEntityName: "SensorEntity",
                                                         in: context)?
            .attributesByName
            .values.first(where: { $0.name == "id" }) else {
            return Fail(error: CoreDataError.objectNotFound)
                .eraseToAnyPublisher()
        }
        return repositories.fetchCount(type: SensorEntity.self, predicate: condition, relationshipKeysToFetch: ["assessment"],
            attribute: attribute, managedObjectContext: context)
    }
    
    func remove(sensor: [SensorModel]) -> AnyPublisher<Void, Error> {
        let context = contextManager.getBackgroundContext()
        func createRemovePublisher(forSensor: SensorModel) -> AnyPublisher<Void,Error> {
            let condition = NSPredicate(format: "id == %@", forSensor.id.uuidString)
            let task = repositories.delete(type: SensorEntity.self,
                                             predicate: condition,
                                             managedObjectContext: context)
            return task
        }
        let startTask = createRemovePublisher(forSensor: sensor[0])
        let sensors = Array(sensor.dropFirst())
        let task = sensors.reduce(startTask) { partialResult, model in
            return partialResult
                .merge(with: createRemovePublisher(forSensor: model))
                .eraseToAnyPublisher()
        }
        return task
    }
}
