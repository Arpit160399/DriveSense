//
//  CreateAssessementUseCase.swift
//  DriveSense
//
//  Created by Arpit Singh on 30/10/22.
//
import Combine
import Foundation
class CreateAssessmentUseCase: UseCase {
    
    private var task: Set<AnyCancellable>
    private let assessmentDataLayer: AssessmentDataLayer
    private var assessment: AssessmentModel
    private let actionDispatcher: ActionDispatcher
    
    init(assessmentDataLayer: AssessmentDataLayer,
         assessment: AssessmentModel,
         actionDispatcher: ActionDispatcher) {
        self.task = Set<AnyCancellable>()
        self.assessmentDataLayer = assessmentDataLayer
        self.assessment = assessment
        self.actionDispatcher = actionDispatcher
    }
    
    func start() {
        let action = MockTestAction.generatingAssessment()
        actionDispatcher.dispatch(action)
        assessmentDataLayer.create(assessment: assessment)
            .sink { completion in
                if case .failure(_ ) = completion {
                    let errorMessage = ErrorMessage(title: "Error Occurred",
                                                    message: "error Happened will set up mock test environment")
                    let action = MockTestAction.MockTestError(error: errorMessage)
                    self.actionDispatcher.dispatch(action)
                }
            } receiveValue: { model in
                let action = MockTestAction.updateAssessment(assessment: model)
                self.actionDispatcher.dispatch(action)
            }.store(in: &task)
    }
    
}

protocol CreateAssessmentUserCaseFactory {
    func makeCreateAssessmentUseCase(forAssessment: AssessmentModel) -> UseCase
}
