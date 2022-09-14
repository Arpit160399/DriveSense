//
//  ADIEntity+CoreDataProperties.swift
//  DriveSense
//
//  Created by Arpit Singh on 02/09/22.
//
//

import Foundation
import CoreData


extension ADIEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ADIEntity> {
        return NSFetchRequest<ADIEntity>(entityName: "ADIEntity")
    }

    @NSManaged public var expiryDate: String
    @NSManaged public var no: String
    @NSManaged public var instructor: InstructorEntity?

}

extension ADIEntity : Identifiable {

}


extension ADIEntity : DomainModel {
    
    func intoObject(from: ADIModel,context: NSManagedObjectContext) {
        no = from.no
        expiryDate = from.expiryDate
    }
    
    func toDomainModel() -> ADIModel {
         return ADIModel(no: no, expiryDate: expiryDate)
    }
}
