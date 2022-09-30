//
//  CandidatesEntity+CoreDataProperties.swift
//  DriveSense
//
//  Created by Arpit Singh on 02/09/22.
//
//

import Foundation
import CoreData


extension CandidatesEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CandidatesEntity> {
        return NSFetchRequest<CandidatesEntity>(entityName: "CandidatesEntity")
    }

    @NSManaged public var address: String
    @NSManaged public var dateOfBirth: Double
    @NSManaged public var id: UUID
    @NSManaged public var name: String
    @NSManaged public var createdAt: Double
    @NSManaged public var assessment: NSSet
    @NSManaged public var instructor: InstructorEntity

}

// MARK: Generated accessors for assessment
extension CandidatesEntity {

    @objc(addAssessmentObject:)
    @NSManaged public func addToAssessment(_ value: AssessmentEntity)

    @objc(removeAssessmentObject:)
    @NSManaged public func removeFromAssessment(_ value: AssessmentEntity)

    @objc(addAssessment:)
    @NSManaged public func addToAssessment(_ values: NSSet)

    @objc(removeAssessment:)
    @NSManaged public func removeFromAssessment(_ values: NSSet)

}

extension CandidatesEntity : Identifiable {

}

extension CandidatesEntity : DomainModel {
   
    func intoObject(from: CandidatesModel,context: NSManagedObjectContext) {
        id = from.id
        name = from.name ?? ""
        dateOfBirth = from.dateOfBirth ?? 0
        address = from.address ?? ""
        createdAt = from.createdAt ?? Date().timeIntervalSince1970
    }
    
    func toDomainModel() -> CandidatesModel {
        return CandidatesModel(id: id, name: name,
                               dateOfBirth: dateOfBirth,
                               address: address,
                               createdAt: createdAt,
                               instructor: instructor.toDomainModel())
    }
}
