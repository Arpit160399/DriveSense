//
//  AssessmentEntity+CoreDataProperties.swift
//  DriveSense
//
//  Created by Arpit Singh on 03/09/22.
//
//

import Foundation
import CoreData


extension AssessmentEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<AssessmentEntity> {
        return NSFetchRequest<AssessmentEntity>(entityName: "AssessmentEntity")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var avgSpeed: Double
    @NSManaged public var totalDistance: Double
    @NSManaged public var createdAt: Double
    @NSManaged public var forCandidate: CandidatesEntity?
    @NSManaged public var byInstuctor: InstructorEntity?
    @NSManaged public var sensor: NSSet?
    @NSManaged public var feedback: FeedbackEntity?

}

// MARK: Generated accessors for sensor
extension AssessmentEntity {

    @objc(addSensorObject:)
    @NSManaged public func addToSensor(_ value: SensorEntity)

    @objc(removeSensorObject:)
    @NSManaged public func removeFromSensor(_ value: SensorEntity)

    @objc(addSensor:)
    @NSManaged public func addToSensor(_ values: NSSet)

    @objc(removeSensor:)
    @NSManaged public func removeFromSensor(_ values: NSSet)

}

extension AssessmentEntity : Identifiable {

}

extension AssessmentEntity : DomainModel {
    
    func intoObject(from: AssessmentModel,
                    context: NSManagedObjectContext) {
        id = from.id
        totalDistance = from.totalDistance ?? 0
        avgSpeed = from.avgSpeed ?? 0
        totalDistance = from.totalDistance ?? 0
        createdAt = from.createdAt ?? Date().timeIntervalSince1970
        if let testResult = from.feedback {
            let object = feedback != nil ? feedback : FeedbackEntity(context: context)
            object?.intoObject(from: testResult, context: context)
            feedback = object
        }
    }

    func toDomainModel() -> AssessmentModel {
        return .init(id: id ?? UUID(),
                     totalDistance: totalDistance, avgSpeed: avgSpeed,
                     conductedBy: byInstuctor?.toDomainModel(),
                     ofCandidate: forCandidate?.toDomainModel(),
                     feedback: feedback?.toDomainModel(),
                     createdAt: createdAt
                    )
    }
    
}
