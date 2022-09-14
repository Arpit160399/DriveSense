//
//  Gyroscope.swift
//  DriveSense
//
//  Created by Arpit Singh on 14/08/22.
//

import Foundation
import CoreMotion
class GyroscopeSensor {
    private let motion: CMMotionManager
    
    enum GyroError: Swift.Error {
        case noGyroSensor
        
        var description: String {
            switch self {
            case .noGyroSensor:
                   return "Current do not has GyroScope"
            }
        }
    }
    

    
    init(_ manager: CMMotionManager = CMMotionManager()) throws {
        guard manager.isGyroAvailable else {
            throw GyroError.noGyroSensor
        }
            motion = manager
            motion.startAccelerometerUpdates()
    }
    
    deinit {
        motion.stopAccelerometerUpdates()
    }
 
    func getGyro() throws ->  AxisValue {
        guard motion.isGyroActive else {
            throw GyroError.noGyroSensor
        }
        if let data  = motion.gyroData?.rotationRate {
            return AxisValue(x: Float(data.x), y: Float(data.y), z: Float(data.z))
        }
        return .none
    }
    
}
