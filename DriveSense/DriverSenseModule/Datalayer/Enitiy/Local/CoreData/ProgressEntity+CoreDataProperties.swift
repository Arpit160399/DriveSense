//
//  ProgressEntity+CoreDataProperties.swift
//  DriveSense
//
//  Created by Arpit Singh on 02/09/22.
//
//

import Foundation
import CoreData


extension ProgressEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ProgressEntity> {
        return NSFetchRequest<ProgressEntity>(entityName: "ProgressEntity")
    }

    @NSManaged public var appropriatedSpeed: String
    @NSManaged public var undueHesitation: String
    @NSManaged public var assessment: FeedbackEntity?

}

extension ProgressEntity : Identifiable {

}

extension ProgressEntity : DomainModel {
    
    func intoObject(from: ProgressModel,context: NSManagedObjectContext) {
        appropriatedSpeed = from.appropriatedSpeed ?? ""
        undueHesitation = from.undueHesitation ?? ""
    }
    
    func toDomainModel() -> ProgressModel {
        return .init(appropriatedSpeed: appropriatedSpeed,
                     undueHesitation: undueHesitation)
    }
}
