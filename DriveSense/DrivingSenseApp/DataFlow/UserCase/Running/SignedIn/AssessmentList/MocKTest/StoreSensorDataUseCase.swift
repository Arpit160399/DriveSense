//
//  StoreSensorDataUseCase.swift
//  DriveSense
//
//  Created by Arpit Singh on 30/10/22.
//
import Combine
import Foundation
class StoreSensorDataUseCase: UseCase {
    
    private var task: Set<AnyCancellable>
    private let assessmentDataLayer: AssessmentDataLayer
    private let forAssessment: AssessmentModel
    private let actionDispatcher: ActionDispatcher
    private let sensorDataProvider: SensorHandler
    private let size: Int
    private let interval: TimeInterval
    
    init(assessmentDataLayer: AssessmentDataLayer,
         forAssessment: AssessmentModel,
         actionDispatcher: ActionDispatcher,
         sensorDataProvider: SensorHandler,
         bufferSize: Int = 10,
         interval: TimeInterval = 5) {
        self.assessmentDataLayer = assessmentDataLayer
        self.forAssessment = forAssessment
        self.task = Set<AnyCancellable>()
        self.actionDispatcher = actionDispatcher
        self.sensorDataProvider = sensorDataProvider
        self.size = bufferSize
        self.interval = interval
    }
    
    
    func start() {
         sensorDataProvider
        .collectSensorData(interval)
        .map({ $0.toSensorModel() })
        .collect(size)
        .sink { completion in
            if case .failure(let error) = completion {
                let error = ErrorMessage(title: "Error Occurred", message: error.localizedDescription)
                let action = MockTestAction.MockTestError(error: error)
                self.actionDispatcher.dispatch(action)
            }
        } receiveValue: { sensors in
            self.uploadDataFor(sensors: sensors)
        }.store(in: &task)
    }


   fileprivate func uploadDataFor(sensors: [SensorModel]) {
        assessmentDataLayer.collect(sensor: sensors,
                                    forAssessment: forAssessment)
        .sink { completion in
            if case .failure(_ ) = completion {
                let error = ErrorMessage(title: "Error Occurred", message: "Unable to Gather data from sensor at the moment.")
                let action = MockTestAction.MockTestError(error: error)
                self.actionDispatcher.dispatch(action)
            }
        } receiveValue: { model in
            let action = MockTestAction.updateAssessment(assessment: model)
            self.actionDispatcher.dispatch(action)
        }.store(in: &task)
    }
    
}

protocol StoreSensorDataUseCaseFactory {
    func makeStoreSensorDateUseCase(forAssessment: AssessmentModel) -> UseCase
}


extension Sensor {
    // Converting Sensor Data To Sensor Model
      func toSensorModel() -> SensorModel {
        
          let gyroModel = self.gyro.toAxisValueModel()
          let accelerometerModel = self.accelerometer.toAxisValueModel()
          let linearAccelerometerModel = self.linearAccelerometer.toAxisValueModel()
          // Converting GPS Data to GPS Model
          let gpsModel = GPSModel(longitude: Double(self.gps.longitude),
                                  latitude: Double(self.gps.latitude))
         
          return SensorModel(id: UUID(),verdict: self.verdict,speed: self.speed,
                             time: self.time,direction: self.direction.rawValue,
                             distance: self.distance,accelerometer: accelerometerModel,gps: gpsModel,
                             gyro: gyroModel,linearAccelerometer: linearAccelerometerModel)
    }
}

extension AxisValue {
    // Converting axis Data To Axis Model
    func toAxisValueModel() -> AxisValueModel {
        return .init(x: self.x,y: self.y,z: self.z)
    }
}
