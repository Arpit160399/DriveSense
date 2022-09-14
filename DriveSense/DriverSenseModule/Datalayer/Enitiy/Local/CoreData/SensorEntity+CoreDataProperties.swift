//
//  SensorEntity+CoreDataProperties.swift
//  DriveSense
//
//  Created by Arpit Singh on 02/09/22.
//
//

import Foundation
import CoreData


extension SensorEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SensorEntity> {
        return NSFetchRequest<SensorEntity>(entityName: "SensorEntity")
    }

    @NSManaged public var direction: String
    @NSManaged public var id: UUID
    @NSManaged public var speed: Double
    @NSManaged public var time: Double
    @NSManaged public var verdict: String
    @NSManaged public var distance: Double
    @NSManaged public var accelerometer: AxisValueEntity?
    @NSManaged public var assessment: AssessmentEntity?
    @NSManaged public var gps: GPSEntity?
    @NSManaged public var gyro: AxisValueEntity?
    @NSManaged public var linearAccelerometer: AxisValueEntity?

}

extension SensorEntity : Identifiable {

}

extension SensorEntity : DomainModel {
    
    func intoObject(from: SensorModel,context: NSManagedObjectContext) {
        id = from.id
        verdict = from.verdict ?? ""
        speed = from.speed ?? 0
        direction = from.direction ?? ""
        time = from.time ?? 0
        distance = from.distance ?? 0
        if let gpsSet = from.gps {
        gps = setGps(context: context, value: gpsSet)
        }
        if let linear = from.linearAccelerometer {
           linearAccelerometer = setAxisValue(context: context,
                                accelerometerValue: linear)
        }
        if let accelerationValue = from.accelerometer {
            accelerometer = setAxisValue(context: context,
                            accelerometerValue: accelerationValue)
        }
    }
    
    private func setAxisValue(context: NSManagedObjectContext,
                                  accelerometerValue: AxisValueModel) -> AxisValueEntity {
        let object = AxisValueEntity(context: context)
        object.intoObject(from: accelerometerValue, context: context)
        return object
    }
    
    private func setGps(context: NSManagedObjectContext,
                        value: GPSModel) -> GPSEntity {
        let object = GPSEntity(context: context)
        object.intoObject(from: value, context: context)
        return object
    }
    
    func toDomainModel() -> SensorModel {
        return .init(id: id, verdict: verdict, speed: speed, time: time,distance: distance,
            accelerometer: accelerometer?.toDomainModel(),
            gps: gps?.toDomainModel(),
            gyro: gyro?.toDomainModel(),
            linearAccelerometer: linearAccelerometer?.toDomainModel())
    }
}
