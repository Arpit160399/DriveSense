//
//  CloudSyncAssessmentUseCase.swift
//  DriveSense
//
//  Created by Arpit Singh on 01/01/23.
//
import Combine
import Foundation
class CloudSyncAssessmentUseCase: UseCase {
    
    // MARK: - property
    
    private var task: Set<AnyCancellable>
    private let assessmentDataLayer: AssessmentDataLayer
    private let candidate: CandidatesModel
    private let actionDispatcher: ActionDispatcher
    
    // MARK: - method
    init(assessmentDataLayer: AssessmentDataLayer,
         candidate: CandidatesModel,
         actionDispatcher: ActionDispatcher) {
        self.task = Set<AnyCancellable>()
        self.assessmentDataLayer = assessmentDataLayer
        self.candidate = candidate
        self.actionDispatcher = actionDispatcher
    }
    
    func start() {
        let action = AssessmentListAction.SyncingBegin()
        actionDispatcher.dispatch(action)
        assessmentDataLayer
            .syncAssessment()
            .subscribe(on: DispatchQueue.global())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    var errorMg = ErrorMessage(title: "Error Occurred", message: "unable fetch the assessment list at current moment.")
                    if case NetworkError.serverWith(let error) = error {
                        errorMg.message = error.message
                    }
                    let action = AssessmentListAction.PresentedError(error: errorMg)
                    self.actionDispatcher.dispatch(action)
                }
            }, receiveValue: { assessments in
                let action = AssessmentListAction.SyncingEnded(newList: assessments)
                self.actionDispatcher.dispatch(action)
            }).store(in: &task)
    }
    
}
protocol CloudSyncAssessmentUseCaseFactory {
    func makeCloudSyncAssessmentUseCase(candidate: CandidatesModel) -> UseCase
}
