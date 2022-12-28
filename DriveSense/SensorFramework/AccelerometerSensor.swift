//
//  Accelerometer.swift
//  DriveSense
//
//  Created by Arpit Singh on 11/08/22.
//

import Foundation
import CoreMotion
class AccelerometerSensor {
    private let motion: CMMotionManager
    
    enum AccelerometerError: Swift.Error {
        case noAccelerometerSensor
        
        var description: String {
            switch self {
            case .noAccelerometerSensor:
                   return "Current do not has accelerometer"
            }
        }
    }
    
    init(_ manager: CMMotionManager = CMMotionManager()) throws {
        guard manager.isAccelerometerAvailable else {
            throw AccelerometerError.noAccelerometerSensor
        }
            motion = manager
            motion.startAccelerometerUpdates()
            motion.startDeviceMotionUpdates()
    }
    
    deinit {
        motion.stopAccelerometerUpdates()
        motion.stopDeviceMotionUpdates()
    }
 
    func getLinearAccelerometer() -> AxisValue {
        guard motion.isAccelerometerActive else {
            return .none
        }
        if let data = motion.deviceMotion?.userAcceleration {
            return AxisValue(x: Float(data.x), y: Float(data.y), z: Float(data.z))
        }
        return .none
    }
    
    func getAccelerometer() -> AxisValue {
        guard motion.isAccelerometerActive else {
            return .none
        }
        if let data  = motion.accelerometerData?.acceleration {
            return AxisValue(x: Float(data.x), y: Float(data.y), z: Float(data.z))
        }
        return .none
    }
    
}
