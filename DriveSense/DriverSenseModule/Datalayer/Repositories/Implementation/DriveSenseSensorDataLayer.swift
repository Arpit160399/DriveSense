//
//  DriveSenseSensorDataLayer.swift
//  DriveSense
//
//  Created by Arpit Singh on 29/12/22.
//
import Combine
import Foundation
class DriverSenseSensorDataLayer: SensorDataLayer {

    // MARK: - Propertyes
    private let remoteApi: AssessmentRemoteApi
    private let assessment: AssessmentModel
    
    // MARK: - Methods
    init(remoteApi: AssessmentRemoteApi, assessment: AssessmentModel) {
        self.remoteApi = remoteApi
        self.assessment = assessment
    }
    
    
    func getSensorData(page: Int) -> AnyPublisher<[SensorModel], Error> {
        return remoteApi.getSensor(for: assessment, page: page)
            .mapError { $0 as Error }
            .eraseToAnyPublisher()
    }
    
}
