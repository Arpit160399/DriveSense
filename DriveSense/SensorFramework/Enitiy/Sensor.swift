//
//  Sensor.swift
//  DriveSense
//
//  Created by Arpit Singh on 19/08/22.
//

import Foundation
public struct Sensor {
    var accelerometer: AxisValue
    var linearAccelerometer: AxisValue
    var gyro: AxisValue
    var gps: GPS
    var verdict: String
    var speed: Double
    var time: TimeInterval
    var distance: Double
    var direction: Direction
}
