//
//  FetchAssessmentUseCase.swift
//  DriveSense
//
//  Created by Arpit Singh on 23/10/22.
//
import Combine
import Foundation
class FetchAssessmentUseCase: UseCase {
    
    // MARK: - property
    
    private var task: Set<AnyCancellable>
    private let assessmentDataLayer: AssessmentDataLayer
    private let candidate: CandidatesModel
    private let page: Int
    private let actionDispatcher: ActionDispatcher
    
    
    // MARK: - method
    init(assessmentDataLayer: AssessmentDataLayer,
         candidate: CandidatesModel,
         page: Int,
         actionDispatcher: ActionDispatcher){
        self.task = Set<AnyCancellable>()
        self.assessmentDataLayer = assessmentDataLayer
        self.candidate = candidate
        self.page = page
        self.actionDispatcher = actionDispatcher
    }
    
    func start() {
        let action = AssessmentListAction.FetchingList()
        actionDispatcher.dispatch(action)
        let page = page
        assessmentDataLayer.getAssessment(page: page)
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    var errorMg = ErrorMessage(title: "Error Occurred", message: "unable fetch the assessment list at current moment.")
                    if case NetworkError.ServerWith(let error) = error {
                        errorMg.message = error.message
                    }
                    let action = AssessmentListAction.PresentedError(error: errorMg)
                    self.actionDispatcher.dispatch(action)
                }
            }, receiveValue: { assessments in
                let action = AssessmentListAction.FetchedList(list: assessments, page: page)
                self.actionDispatcher.dispatch(action)
            }).store(in: &task)
    }
    
}
protocol FetchAssessmentUseCaseFactory {
    func makeFetchAssessmentUseCase(candidate: CandidatesModel,page: Int) -> UseCase
}
