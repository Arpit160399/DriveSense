//
//  UpdateAssesmentValueUseCase.swift
//  DriveSense
//
//  Created by Arpit Singh on 30/10/22.
//
import Combine
import Foundation
class UpdateFeedBackUseCase: UseCase {
    
    private var task: Set<AnyCancellable>
    private let assessmentDataLayer: AssessmentDataLayer
    private let feedback: FeedbackModel
    private let assessment: AssessmentModel
    private let actionDispatcher : ActionDispatcher
    
    init(assessmentDataLayer: AssessmentDataLayer,
         feedback: FeedbackModel,
         assessment: AssessmentModel,
         actionDispatcher: ActionDispatcher) {
        self.task = Set<AnyCancellable>()
        self.assessmentDataLayer = assessmentDataLayer
        self.feedback = feedback
        self.assessment = assessment
        self.actionDispatcher = actionDispatcher
    }
    
    func start() {
        assessmentDataLayer.update(feedback: feedback,
                                   forAssessment: assessment)
            .sink(receiveCompletion: { completion in
                if case .failure(_ ) = completion {
                    let errorMessage = ErrorMessage(title: "Error Occurred",
                                                    message: "Unable to cache the feedback at the moment.")
                    let action = MockTestAction.MockTestError(error: errorMessage)
                    self.actionDispatcher.dispatch(action)
                }
            }, receiveValue: { _ in }).store(in: &task)
    }
    
}

protocol UpdateFeedbackUseCaseFactory {
    func makeUpdateFeedbackUseCase(feedback: FeedbackModel,forAssessment: AssessmentModel) -> UseCase
}
