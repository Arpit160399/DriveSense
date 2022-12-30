//
//  FetchSensorDataUseCase.swift
//  DriveSense
//
//  Created by Arpit Singh on 29/12/22.
//
import Combine
import Foundation
class FetchSensorDataUseCase: UseCase {
    
    private var dispatcher: ActionDispatcher
    private var remoteApi: SensorDataLayer
    private var task: Set<AnyCancellable>
    
    init(dispatcher: ActionDispatcher, remoteApi: SensorDataLayer) {
        self.dispatcher = dispatcher
        self.remoteApi = remoteApi
        self.task = Set<AnyCancellable>()
    }
    
    func start() {
        let action = AssessmentDetailAction.FetchingDataStarted()
        dispatcher.dispatch(action)
        remoteApi.getSensorData(page: 0)
            .sink { completion in
                if case .failure(let error)  = completion {
                    var errorMg = ErrorMessage(title: "Error Occurred", message: "Unable To Fetch Sensor At Moment.")
                    if case NetworkError.serverWith(let error) = error {
                        errorMg.message = error.message
                    }
                    let action = AssessmentDetailAction
                        .PresentError(error: errorMg)
                    self.dispatcher.dispatch(action)
                }
            } receiveValue: { sensors in
                let action = AssessmentDetailAction
                    .FetchedSensorValue(sensor: sensors)
                self.dispatcher.dispatch(action)
            }.store(in: &task)
    }
    
}

protocol FetchSensorDataUseCaseFactory {
    
    func makeFetchSensorDataUseCase(forAssessment: AssessmentModel) -> UseCase
    
}
