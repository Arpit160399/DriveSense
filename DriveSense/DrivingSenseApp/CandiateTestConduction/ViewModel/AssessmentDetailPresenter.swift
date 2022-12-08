//
//  AssessmentDetailPresenter.swift
//  DriveSense
//
//  Created by Arpit Singh on 22/10/22.
//

import SwiftUI
import Combine
class AssessmentDetailPresenter: ObservableObject {
    
    //MARK: - Property
    // View States
    @Published var state: AssessmentListState
    @Published var showError: Bool = false
    @Published var navigation: NavigationModel = .none
    
    private let candidate: CandidatesModel
    private let actionDispatcher: ActionDispatcher
    
    ///Child View
    private let testBoardViewFactory: (MockTestState) -> TestBoardView
    
    ///Use Cases
    private let fetchAssessmentUseCaseFactory: FetchAssessmentUseCaseFactory
    
    //MARK: - Methods
    init(state: AssessmentListState,
         candidate: CandidatesModel,
         actionDispatcher: ActionDispatcher,
         testBoardViewFactory: @escaping (MockTestState) -> TestBoardView,
         fetchAssessmentUseCaseFactory: FetchAssessmentUseCaseFactory) {
        self.state = state
        self.showError = !state.errorPresenter.isEmpty
        self.candidate = candidate
        self.actionDispatcher = actionDispatcher
        self.fetchAssessmentUseCaseFactory = fetchAssessmentUseCaseFactory
        self.testBoardViewFactory = testBoardViewFactory
        navigateTo()
    }
    
    func conductMockTest() {
        let action = AssessmentListAction.PresentMockTesting(candidate: candidate)
        send(action)
    }
    
    func getAssessmentFor(page: Int) {
        let useCase = fetchAssessmentUseCaseFactory
            .makeFetchAssessmentUseCase(candidate: candidate, page: page)
        useCase.start()
    }
    
    func send(_ action: Action) {
        actionDispatcher.dispatch(action)
    }
    
    private func navigateTo() {
        switch state.viewState {
         case .MockTest(let mockTestState):
            let view = testBoardViewFactory(mockTestState)
            navigation = .init(isDisplayed: true,destination: AnyView(view))
         default:
               break
        }
    }
    
}
