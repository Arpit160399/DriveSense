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
    
//  deinit {
//      sensorDataProvider.stopCollection()
//      task.forEach({ $0.cancel() })
//  }
    
  func start() {
         sensorDataProvider
        .collectSensorData(interval)
        .map({ $0.toSensorModel() })
        .sink {  completion in
            if case .failure(let error) = completion {
                let error = ErrorMessage(title: "Error Occurred", message: error.localizedDescription)
                let action = MockTestAction.MockTestError(error: error)
                self.actionDispatcher.dispatch(action)
            }
        } receiveValue: {  sensor in
            let action = MockTestAction.UpdatedDrivingState(speed: sensor.speed ?? 0,
                                                            distance: sensor.distance ?? 0,
                                                            direction: sensor.direction ?? "")
            self.actionDispatcher.dispatch(action)
            self.uploadDataFor(sensors: sensor)
        }.store(in: &task)
    }

 fileprivate func uploadDataFor(sensors: SensorModel) {
        assessmentDataLayer
        .collect(sensor: sensors,forAssessment: forAssessment)
        .subscribe(on: DispatchQueue.global())
        .receive(on: DispatchQueue.main)
        .sink {  completion in
            if case .failure(_) = completion {
                let errorMg = ErrorMessage(title: "Error Occurred", message: "Unable to Gather data from sensor at the moment.")
                let action = MockTestAction.MockTestError(error: errorMg)
                self.actionDispatcher.dispatch(action)
            }
        } receiveValue: { _ in
  //          self.sensorDataProvider.stopCollection()
//            let action = MockTestAction.UpdateAssessment(assessment: model)
//            self.actionDispatcher.dispatch(action)
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
                             distance: self.distance,
                             pressure: self.pressure,course: self.course,compass: self.compass,
                             accelerometer: accelerometerModel,gps: gpsModel,
                             gyro: gyroModel,linearAccelerometer: linearAccelerometerModel)
    }
}

extension AxisValue {
    // Converting axis Data To Axis Model
    func toAxisValueModel() -> AxisValueModel {
        return .init(x: self.x,y: self.y,z: self.z)
    }
}
