//
//  InstructorEntity+CoreDataProperties.swift
//  DriveSense
//
//  Created by Arpit Singh on 02/09/22.
//
//

import Foundation
import CoreData


extension InstructorEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<InstructorEntity> {
        return NSFetchRequest<InstructorEntity>(entityName: "InstructorEntity")
    }

    @NSManaged public var address: String?
    @NSManaged public var email: String?
    @NSManaged public var id: UUID?
    @NSManaged public var name: String?
    @NSManaged public var postcode: String?
    @NSManaged public var createdAt: Double
    @NSManaged public var adi: ADIEntity?
    @NSManaged public var assessment: NSSet?
    @NSManaged public var students: NSSet?

}

// MARK: Generated accessors for assessment
extension InstructorEntity {

    @objc(addAssessmentObject:)
    @NSManaged public func addToAssessment(_ value: AssessmentEntity)

    @objc(removeAssessmentObject:)
    @NSManaged public func removeFromAssessment(_ value: AssessmentEntity)

    @objc(addAssessment:)
    @NSManaged public func addToAssessment(_ values: NSSet)

    @objc(removeAssessment:)
    @NSManaged public func removeFromAssessment(_ values: NSSet)

}

// MARK: Generated accessors for students
extension InstructorEntity {

    @objc(addStudentsObject:)
    @NSManaged public func addToStudents(_ value: CandidatesEntity)

    @objc(removeStudentsObject:)
    @NSManaged public func removeFromStudents(_ value: CandidatesEntity)

    @objc(addStudents:)
    @NSManaged public func addToStudents(_ values: NSSet)

    @objc(removeStudents:)
    @NSManaged public func removeFromStudents(_ values: NSSet)

}

extension InstructorEntity : Identifiable {

}

extension InstructorEntity : DomainModel {
    
    func intoObject(from: InstructorModel, context: NSManagedObjectContext) {
        id = from.id
        name = from.name ?? ""
        email = from.email ?? ""
        postcode = from.postcode ?? ""
        address = from.address ?? ""
        createdAt = from.createdAt ?? Date().timeIntervalSince1970
        if let adiValue = from.adi {
        adi = setAdi(context: context, value: adiValue)
       }
    }
    
    fileprivate func setAdi(context: NSManagedObjectContext,
                            value: ADIModel) -> ADIEntity {
        let object = ADIEntity(context: context)
        object.intoObject(from: value, context: context)
        return object
    }
    
    func toDomainModel() -> InstructorModel {
        return InstructorModel(id: id ?? UUID(), name: name, email: email,
                               postcode: postcode, address: address,
                               adi: adi?.toDomainModel(), createdAt:  createdAt)
    }
}
