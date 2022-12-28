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
    private let barometer: CMAltimeter
    private var currentPressure :Double = 0
    private let operationQueue = DispatchQueue(label: "pressure.sensor")
    private let lock = NSLock()
    
    enum GyroError: Swift.Error {
        case noGyroSensor
        
        var description: String {
            switch self {
            case .noGyroSensor:
                   return "Current do not has GyroScope"
            }
        }
    }
        
    init(_ manager: CMMotionManager = CMMotionManager()) {
        //        guard manager.isGyroAvailable else {
        //            throw GyroError.noGyroSensor
        //        }
        motion = manager
        motion.startGyroUpdates()
        barometer = CMAltimeter()
        barometer.startRelativeAltitudeUpdates(to: .main) { [weak self] (data, error) in
            guard let self = self else { return }
            guard let data = data else { print(error!); return }
            self.currentPressure = Double(exactly: data.pressure) ?? 0
        }
    }
    deinit {
        motion.stopGyroUpdates()
        barometer.stopRelativeAltitudeUpdates()
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
    
    func getPressure() -> Double {
        return currentPressure
    }
    
}
