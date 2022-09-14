//
//  SensorHandler.swift
//  DriveSense
//
//  Created by Arpit Singh on 15/08/22.
//
import Combine
import CoreMotion
import Foundation
class SensorHandler {
    
    private let motion: CMMotionManager
    private let gps: GPSSensor
    private let accelerometer: AccelerometerSensor
    private let gyro: GyroscopeSensor
    private let serialQueue: DispatchQueue
    private var schedule: Cancellable
    private var prevSpeed: Double = 0
    private var prevDirection: Double = 0
    private var isInReverse: Bool = false


    init() throws {
        motion = CMMotionManager()
        gps = GPSSensor()
        accelerometer = try AccelerometerSensor(motion)
        gyro = try GyroscopeSensor(motion)
        serialQueue = DispatchQueue(label: "sensor")
        schedule = AnyCancellable({})
    }
    
    deinit {
        schedule.cancel()
    }
    
    func collectSensorData() -> AnyPublisher<Sensor,Never> {
         let subject = PassthroughSubject<Sensor,Never>()
         schedule.cancel()
         schedule = serialQueue.schedule(after: serialQueue.now,
                                        interval: .seconds(10), {
             if let sensor = try? self.collectData() {
                 subject.send(sensor)
             }
         })
        return subject.subscribe(on: serialQueue).eraseToAnyPublisher()
    }
    
    fileprivate func getTheDrivingState(direction: Double,speed: Double) -> (direction: Direction,verdict: String) {
        let accelerationState = getAccelerationState(bySpeed: speed)
        defer {
            prevDirection = direction
        }
        var currentDirection = Direction.movingForward
        //TODO: Add Direction Resolution Function
        
        if !isInReverse , isConstant(direction: direction) {
            currentDirection = .movingForward
        } else if detectTheReverseDrivingIn(direction: direction) || isInReverse  {
            currentDirection = .movingBackward
        } else if direction > prevDirection {
            currentDirection = .rightTurn
        } else {
            currentDirection = .leftTurn
        }
        
        return ( currentDirection, "\(currentDirection.rawValue) \(accelerationState)" )
    }
    
    
    fileprivate func detectTheReverseDrivingIn(direction: Double,constantOffset: Double = 30) -> Bool {
        let maxDegree: Double = 360
        var leftLimit = prevDirection
        var rightLimit = prevDirection
        let offset = constantOffset > 10 ? constantOffset : 10
        for _ in 0..<(Int(180 / offset) - 1)  {
               leftLimit += constantOffset
               rightLimit -= constantOffset
            if leftLimit >= maxDegree {
               leftLimit = 0
            }
            if rightLimit <= 0 {
               rightLimit = maxDegree
            }
         }
        let leftSide = max(leftLimit, rightLimit) , rightSide = min(leftLimit,rightLimit)
        if leftSide >= direction , rightSide <= direction {
            isInReverse.toggle()
            return true
        } else {
            return false
        }
    }

    fileprivate func isConstant(direction: Double) -> Bool {
        let constantOffset: Double = 30
        let maxDegree: Double = 360
        if prevDirection > constantOffset {
            if (prevDirection - constantOffset) <= direction , direction <= (prevDirection + constantOffset) {
                return true
            } else {
                return false
            }
        } else {
            let offset = prevDirection == 0 ? maxDegree - constantOffset : prevDirection
            if prevDirection == 0 {
                if offset <= direction || ((direction > 0) &&
                                           direction <= (prevDirection + constantOffset)) {
                    return true
                } else {
                    return false
                }
            } else {
                if (prevDirection - offset) <= direction , direction <= (prevDirection + offset) {
                    return true
                } else {
                    return false
                }
            }
        }
    }
    
    fileprivate func getAccelerationState(bySpeed: Double) -> String {
        let speedOffset:Double  = 50
        defer {
            prevSpeed = bySpeed
        }
        if (bySpeed > (prevSpeed - speedOffset)) , (bySpeed < (prevSpeed + speedOffset)){
            return "constant acceleration"
        } else if bySpeed > prevSpeed {
            return "increased acceleration"
        } else {
            return "decreased acceleration"
        }
    }
    
    
    fileprivate func collectData() throws -> Sensor {
        let speed = try gps.getSpeed()
        let direction = try gps.getDirection()
        let distance = try gps.getDistance()
        let gpsValue = try gps.getLocation()
        let accelerate =  accelerometer.getAccelerometer()
        let gyro = try gyro.getGyro()
        let linear = accelerometer.getLinearAccelerometer()
        let driverState = getTheDrivingState(direction: direction, speed: speed)
        // converting (meter/second) to (miles/hours)
        let milesPerHourSpeed = speed * 2.236936
        // converting meter to miles
        let distanceInMiles = distance *  0.0006213712
        return Sensor(accelerometer: accelerate, linearAccelerometer: linear,
                      gyro: gyro, gps: gpsValue,
                      verdict: driverState.verdict, Speed: milesPerHourSpeed,
                      time: Date().timeIntervalSince1970,
                      distance: distanceInMiles,
                      direction: driverState.direction)
    }
    
}
