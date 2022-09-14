//
//  ControlEntity+CoreDataProperties.swift
//  DriveSense
//
//  Created by Arpit Singh on 02/09/22.
//
//

import Foundation
import CoreData


extension ControlEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ControlEntity> {
        return NSFetchRequest<ControlEntity>(entityName: "ControlEntity")
    }

    @NSManaged public var acceleration: String
    @NSManaged public var clutch: String
    @NSManaged public var footBreak: String
    @NSManaged public var gear: String
    @NSManaged public var parkingBreak: String
    @NSManaged public var steering: String
    @NSManaged public var assessment: FeedbackEntity?

}

extension ControlEntity : Identifiable {

}

extension ControlEntity : DomainModel {
    
    func intoObject(from: ControlModel,context: NSManagedObjectContext) {
        acceleration = from.acceleration
        footBreak = from.footBreak
        steering = from.steering
        parkingBreak = from.parkingBreak
        clutch = from.clutch
        gear = from.gear
    }
    
    func toDomainModel() -> ControlModel {
        return .init(acceleration: acceleration, footBreak: footBreak,
                     steering: steering, parkingBreak: parkingBreak,
                     clutch: clutch, gear: gear)
    }
}
