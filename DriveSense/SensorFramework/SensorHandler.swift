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
    // MARK: - Property
    
    private let motion: CMMotionManager
    private let gps: GPSSensor
    private let accelerometer: AccelerometerSensor?
    private let gyroSensor: GyroscopeSensor
    private let serialQueue: DispatchQueue
    private var schedule: Cancellable
    private var prevSpeed: Double = 0
    private var prevDirection: Double = 0
    private var isInReverse: Bool = false
        
    // MARK: - Method
    
    init() {
        motion = CMMotionManager()
        gps = GPSSensor()
        accelerometer = try? AccelerometerSensor(motion)
        gyroSensor = GyroscopeSensor(motion)
        serialQueue = DispatchQueue(label: "sensor")
        schedule = AnyCancellable {}
    }
    
    deinit {
        schedule.cancel()
    }
    
    /// send aggregated sensor value collect from phone according given driving state.
    /// - Parameter interval: the seconds of interval in which sensor data need to fetched
    /// - Returns: An continues publisher with sensor as completion value.
    func collectSensorData(_ interval: TimeInterval) -> AnyPublisher<Sensor, Error> {
        let subject = PassthroughSubject<Sensor, Error>()
        schedule.cancel()
        schedule = serialQueue.schedule(after: serialQueue.now,
                                        interval: .seconds(interval)) {
            do {
                let sensor = try self.collectData()
                subject.send(sensor)
            } catch {
                subject.send(completion: .failure(error))
            }
        }
        return subject.subscribe(on: serialQueue).eraseToAnyPublisher()
    }
    
    /// To cancel the sensor data passing scheduler.
    func stopCollection() {
        schedule.cancel()
    }
    
    fileprivate func getTheDrivingState(direction: Double,speed: Double,course: Double) -> (direction: Direction, verdict: String) {
        let accelerationState = getAccelerationState(bySpeed: speed)
        let estimatedOffset: CGFloat = 10
        defer {
            prevDirection = direction
        }
        var currentDirection = Direction.movingForward
       
        // TODO: Add Direction Resolution Function
        
        if !isInReverse, isConstant(direction: direction) {
            currentDirection = .movingForward
        } else if detectTheReverseDrivingIn(direction: direction) || isInReverse {
            currentDirection = .movingBackward
            isInReverse.toggle()
        } else if direction < prevDirection || (checkForLeftTurn(direction: direction) )  {
            currentDirection = .leftTurn
//        } else if (course - direction) < (180 + estimatedOffset)
//                , (course - direction) > (180 - estimatedOffset) {
//            currentDirection = .movingBackward
        } else {
            currentDirection = .rightTurn
        }
        
        return (currentDirection, "\(currentDirection.rawValue) \(accelerationState)")
    }
    
    fileprivate func checkForLeftTurn(direction: Double) -> Bool {
        let constantOffset: Double = 180
        var endRange = prevDirection , startRange = prevDirection
        for _ in 0 ..< (Int(180 / 10) - 1) {
            endRange -= 10
            if endRange <= 0 {
                endRange = 360
            }
        }
        let leftSide = min(startRange, endRange) , rightSide = max(startRange,endRange)
        if leftSide <= direction , rightSide >= direction {
            return true
        }
        return false
    }
    
    fileprivate func detectTheReverseDrivingIn(direction: Double,
                                               constantOffset: Double = 30) -> Bool {
        let maxDegree: Double = 360
        var leftLimit = prevDirection
        var rightLimit = prevDirection
        let offset = constantOffset > 10 ? constantOffset : 10
        for _ in 0 ..< (Int(180 / offset) - 1) {
            leftLimit += constantOffset
            rightLimit -= constantOffset
            if leftLimit >= maxDegree {
                leftLimit = 0
            }
            if rightLimit <= 0 {
                rightLimit = maxDegree
            }
        }
        let leftSide = max(leftLimit, rightLimit), rightSide = min(leftLimit, rightLimit)
        if leftSide >= direction, rightSide <= direction {
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
            if (prevDirection - constantOffset) <= direction, direction <= (prevDirection + constantOffset) {
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
                if (prevDirection - offset) <= direction, direction <= (prevDirection + offset) {
                    return true
                } else {
                    return false
                }
            }
        }
    }
    
    fileprivate func getAccelerationState(bySpeed: Double) -> String {
        let speedOffset: Double = 50
        defer {
            prevSpeed = bySpeed
        }
        if bySpeed > (prevSpeed - speedOffset), bySpeed < (prevSpeed + speedOffset) {
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
        let accelerate = accelerometer?.getAccelerometer() ?? .none
        let gyro = try gyroSensor.getGyro()
        let pressure = gyroSensor.getPressure()
        let course = try gps.getVehicleCourse()
        let linear = accelerometer?.getLinearAccelerometer() ?? .none
        let driverState = getTheDrivingState(direction: direction, speed: speed,
                                             course: course == -1 ? -600 : course)
        // converting (meter/second) to (miles/hours)
        let milesPerHourSpeed = speed * 2.236936
        // converting meter to miles
        let distanceInMiles = distance * 0.0006213712
        
        return Sensor(accelerometer: accelerate, linearAccelerometer: linear,
                      gyro: gyro, gps: gpsValue,
                      verdict: driverState.verdict, speed: milesPerHourSpeed,
                      time: Date().timeIntervalSince1970,
                      distance: distanceInMiles,
                      pressure: pressure,
                      course: course,
                      compass: direction,
                      direction: driverState.direction)
    }
}
