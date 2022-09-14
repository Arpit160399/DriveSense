//
//  PositioningEntity+CoreDataProperties.swift
//  DriveSense
//
//  Created by Arpit Singh on 02/09/22.
//
//

import Foundation
import CoreData


extension PositioningEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PositioningEntity> {
        return NSFetchRequest<PositioningEntity>(entityName: "PositioningEntity")
    }

    @NSManaged public var laneDiscipline: String?
    @NSManaged public var normalDriving: String?
    @NSManaged public var assessment: FeedbackEntity?

}

extension PositioningEntity : Identifiable {

}

extension PositioningEntity : DomainModel {
    
    func intoObject(from: PositioningModel,context: NSManagedObjectContext) {
        laneDiscipline = from.laneDiscipline
        normalDriving = from.normalDriving
    }
    
    func toDomainModel() -> PositioningModel {
        return .init(normalDriving: normalDriving,
                     laneDiscipline: laneDiscipline)
    }
}
