//
//  SensorEntity+CoreDataProperties.swift
//  DriveSense
//
//  Created by Arpit Singh on 31/08/22.
//
//

import Foundation

struct SensorModel:Identifiable , Codable, Equatable {
    var id: UUID
    var verdict: String?
    var speed: Double?
    var time: Double?
    var direction: String?
    var distance: Double?
    var pressure:Double?
    var course: Double?
    var compass: Double?
    var accelerometer: AxisValueModel?
    var gps: GPSModel?
    var gyro: AxisValueModel?
    var linearAccelerometer: AxisValueModel?
}
