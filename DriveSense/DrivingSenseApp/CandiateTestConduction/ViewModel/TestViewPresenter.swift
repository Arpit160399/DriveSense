//
//  TestViewPresenter.swift
//  DriveSense
//
//  Created by Arpit Singh on 22/10/22.
//

import Foundation
class TestViewPresenter: ObservableObject {
    
    // MARK: - Property
    @Published var state: MockTestState
    @Published var presentTestBoard: Bool = false
    @Published var showError: Bool = false
    @Published var testFeedback: TestMark
    private let actionDispatcher: ActionDispatcher
    
    // Use Case Factory
    private let storeSensorCollectionUseCaseFactory: StoreSensorDataUseCaseFactory
    private let createAssessmentUseCaseFactory: CreateAssessmentUserCaseFactory
    private let updateFeedbackUseCaseFactory: UpdateFeedbackUseCaseFactory
    private let endTestCleanUpFactory: () -> Void
    
    // MARK: - Methods
    init(state: MockTestState,
         actionDispatcher: ActionDispatcher,
         storeSensorCollectionUseCaseFactory: StoreSensorDataUseCaseFactory,
         createAssessmentUseCaseFactory: CreateAssessmentUserCaseFactory,
         updateFeedbackUseCaseFactory: UpdateFeedbackUseCaseFactory,
         endTestCleanUpFactory: @escaping () -> Void) {
        self.state = state
        self.actionDispatcher = actionDispatcher
        self.showError = !state.errorToPresent.isEmpty
        self.createAssessmentUseCaseFactory = createAssessmentUseCaseFactory
        self.storeSensorCollectionUseCaseFactory = storeSensorCollectionUseCaseFactory
        self.updateFeedbackUseCaseFactory = updateFeedbackUseCaseFactory
        self.endTestCleanUpFactory = endTestCleanUpFactory
        self.testFeedback = .init(feedBack: state.assessment.feedback ?? .init(id: UUID()))
        self.manageTestBoardNavigation()
        if state.startSensorCollection {
            startSensorCollection()
        }
    }
    
    func send(_ action: Action) {
        actionDispatcher.dispatch(action)
    }
    
    func createAssessment() {
        let useCase = createAssessmentUseCaseFactory
            .makeCreateAssessmentUseCase(forAssessment: state.assessment)
        useCase.start()
    }
    func endTest() {
        endTestCleanUpFactory()
    }
    func startSensorCollection() {
        
        let userCase = storeSensorCollectionUseCaseFactory
            .makeStoreSensorDateUseCase(forAssessment: state.assessment)
        userCase.start()
//        let action = MockTestAction.UpdateCurrentUserCase(sensorTask: userCase)
//        send(action)
    }
    
    func update(testFeedback: TestMark) {
        let useCase = updateFeedbackUseCaseFactory
            .makeUpdateFeedbackUseCase(feedback: testFeedback.convertToFeedbackModel(),
                                       forAssessment: state.assessment)
        useCase.start()
    }
    
    func getCurrentDirection(value: String) -> CarDirection {
        let direction = Direction(rawValue: value) ?? .movingForward
        switch direction {
        case .leftTurn:
            return CarDirection.left
        case .rightTurn:
            return CarDirection.right
        case .movingForward:
            return CarDirection.forward
        case .movingBackward:
            return CarDirection.backward
        }
    }
    
    fileprivate func manageTestBoardNavigation() {
        switch state.viewState {
        case .testBoard:
             self.presentTestBoard = true
        default:
            self.presentTestBoard = false
        }
    }
}
