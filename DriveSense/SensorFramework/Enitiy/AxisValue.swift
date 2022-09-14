//
//  Accelerometer.swift
//  DriveSense
//
//  Created by Arpit Singh on 19/08/22.
//

import Foundation
public struct AxisValue {
    var x : Float
    var y : Float
    var z : Float
    static let none = AxisValue(x: 0, y: 0, z: 0)
}
