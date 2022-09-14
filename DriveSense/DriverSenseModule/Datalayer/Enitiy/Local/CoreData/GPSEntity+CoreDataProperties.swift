//
//  GPSEntity+CoreDataProperties.swift
//  DriveSense
//
//  Created by Arpit Singh on 02/09/22.
//
//

import Foundation
import CoreData


extension GPSEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<GPSEntity> {
        return NSFetchRequest<GPSEntity>(entityName: "GPSEntity")
    }

    @NSManaged public var latitude: Double
    @NSManaged public var longitude: Double
    @NSManaged public var sensor: SensorEntity?

}

extension GPSEntity : Identifiable {

}

extension GPSEntity : DomainModel {
    
    func intoObject(from: GPSModel,context: NSManagedObjectContext) {
        latitude = from.latitude ?? 0
        longitude = from.longitude ?? 0
    }
    
    
    func toDomainModel() -> GPSModel {
        return GPSModel(longitude: latitude, latitude: longitude)
    }
    
}
