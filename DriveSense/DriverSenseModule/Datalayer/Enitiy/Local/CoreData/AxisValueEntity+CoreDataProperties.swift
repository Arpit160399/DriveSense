//
//  AxisValueEntity+CoreDataProperties.swift
//  DriveSense
//
//  Created by Arpit Singh on 02/09/22.
//
//

import Foundation
import CoreData


extension AxisValueEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<AxisValueEntity> {
        return NSFetchRequest<AxisValueEntity>(entityName: "AxisValueEntity")
    }

    @NSManaged public var x: Double
    @NSManaged public var y: Double
    @NSManaged public var z: Double
    @NSManaged public var acclerometer: SensorEntity?
    @NSManaged public var gyro: SensorEntity?
    @NSManaged public var linearAccelrometer: SensorEntity?

}

extension AxisValueEntity : Identifiable {

}
extension AxisValueEntity : DomainModel {
    
    func intoObject(from: AxisValueModel,context: NSManagedObjectContext) {
        x = Double(from.x ?? 0)
        y = Double(from.y ?? 0) 
        z = Double(from.z ?? 0) 
    }
    
    func toDomainModel() -> AxisValueModel {
        return AxisValueModel(x: Float(x), y: Float(y), z: Float(z))
    }
}
