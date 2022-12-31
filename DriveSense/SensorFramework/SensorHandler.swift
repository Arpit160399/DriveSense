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
    private let drivingState: DrivingState
    private let serialQueue: DispatchQueue
    var schedule: Set<AnyCancellable>
        
    // MARK: - Method
    
    init() {
        motion = CMMotionManager()
        gps = GPSSensor()
        accelerometer = try? AccelerometerSensor(motion)
        gyroSensor = GyroscopeSensor(motion)
        serialQueue = DispatchQueue(label: "sensor")
        schedule = Set<AnyCancellable>()
        drivingState = DrivingState()
    }
    
    deinit {
        schedule.forEach({ $0.cancel() })
    }
    
    /// send aggregated sensor value collect from phone according given driving state.
    /// - Parameter interval: the seconds of interval in which sensor data need to fetched
    /// - Returns: An continues publisher with sensor as completion value.
    func collectSensorData(_ interval: TimeInterval) -> AnyPublisher<Sensor, Error> {
        schedule.forEach({ $0.cancel() })
        let subject = PassthroughSubject<Sensor, Error>()
        serialQueue.schedule(after: serialQueue.now,
                                        interval: .seconds(interval)) {
            print("operation fired")
            do {
                let sensor = try self.collectData()
                subject.send(sensor)
            } catch {
                subject.send(completion: .failure(error))
            }
        }.store(in: &schedule)
        return subject.subscribe(on: serialQueue).eraseToAnyPublisher()
    }
    
    /// To cancel the sensor data passing scheduler.
    func stopCollection() {
        schedule.forEach({ $0.cancel() })
        schedule.removeAll()
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
        let driverState = drivingState.getTheDrivingState(direction: direction,
                                             speed: speed,
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
