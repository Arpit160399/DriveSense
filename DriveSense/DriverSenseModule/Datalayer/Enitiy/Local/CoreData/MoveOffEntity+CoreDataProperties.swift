//
//  MoveOffEntity+CoreDataProperties.swift
//  DriveSense
//
//  Created by Arpit Singh on 02/09/22.
//
//

import Foundation
import CoreData


extension MoveOffEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MoveOffEntity> {
        return NSFetchRequest<MoveOffEntity>(entityName: "MoveOffEntity")
    }

    @NSManaged public var control: String?
    @NSManaged public var safety: String?
    @NSManaged public var assessment: FeedbackEntity?

}

extension MoveOffEntity : Identifiable {

}
extension MoveOffEntity : DomainModel {
    
    func intoObject(from: MoveOffModel,context: NSManagedObjectContext) {
        safety = from.safety
        control = from.control
    }
    
    func toDomainModel() -> MoveOffModel {
        return .init(safety: safety, control: control)
    }
    
}
