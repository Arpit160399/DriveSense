//
//  TestViewPresenter.swift
//  DriveSense
//
//  Created by Arpit Singh on 22/10/22.
//

import Foundation
class TestViewPresenter: ObservableObject {
    
    
    //MARK: - Property
    @Published var state: MockTestState
    @Published var presentTestBoard: Bool = false
    @Published private var showError: Bool = false
    @Published var testFeedback: TestMark
    private let actionDispatcher: ActionDispatcher
    
    // Child Views Factory
    
    
    // Use Case Factory
    private let storeSensorCollectionUseCaseFactory: StoreSensorDataUseCaseFactory
    private let createAssessmentUseCaseFactory: CreateAssessmentUserCaseFactory
    private let updateFeedbackUseCaseFactory: UpdateFeedbackUseCaseFactory
    
    // MARK: -  Methods
    init(state: MockTestState,
         actionDispatcher: ActionDispatcher,
         storeSensorCollectionUseCaseFactory: StoreSensorDataUseCaseFactory,
         createAssessmentUseCaseFactory: CreateAssessmentUserCaseFactory,
         updateFeedbackUseCaseFactory: UpdateFeedbackUseCaseFactory ) {
        self.state = state
        self.actionDispatcher = actionDispatcher
        self.showError = !state.errorToPresent.isEmpty
        self.createAssessmentUseCaseFactory = createAssessmentUseCaseFactory
        self.storeSensorCollectionUseCaseFactory = storeSensorCollectionUseCaseFactory
        self.updateFeedbackUseCaseFactory = updateFeedbackUseCaseFactory
        self.testFeedback = .init(feedBack: state.assessment.feedback ?? .init())
        self.manageTestBoardNavigation()
    }
    
    
    func send(_ action: Action) {
        actionDispatcher.dispatch(action)
    }
    
    func createAssessment()  {
        let useCase = createAssessmentUseCaseFactory
            .makeCreateAssessmentUseCase(forAssessment: state.assessment)
        useCase.start()
    }
    
    func startSensorCollection() {
        let userCase = storeSensorCollectionUseCaseFactory
            .makeStoreSensorDateUseCase(forAssessment: state.assessment)
        userCase.start()
    }
    
    func update(testFeedback: TestMark) {
        let useCase = updateFeedbackUseCaseFactory
            .makeUpdateFeedbackUseCase(feedback: testFeedback.convertToFeedbackModel(),
                                       forAssessment: state.assessment)
        useCase.start()
    }
    
    fileprivate func manageTestBoardNavigation() {
        switch state.viewState {
        case .testBoard(_):
             self.presentTestBoard = true
        default:
                 break
        }
    }
}
