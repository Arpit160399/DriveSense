//
//  DriverSenseCandidateContainer.swift
//  DriveSense
//
//  Created by Arpit Singh on 14/10/22.
//

import Foundation
class DriverSenseCandidateContainer {
    
    // MARK: - Property
    
    private var store: Store<AppState>
    private let userSession: UserSession
    private let candidate: CandidatesModel
    private let sensorDataProvider: SensorHandler
    private let dataLayer: AssessmentDataLayer
    
    // MARK: - Methods
    
    init(container: DriverSenseSignedInContainer,candidate: CandidatesModel) {
        self.store = container.store
        self.userSession = container.useSession
        self.candidate = candidate
        self.sensorDataProvider = container.sensorHandler
        self.dataLayer = DataManager().getAssessmentDataLayer(session: userSession,
                                                             candidate: candidate)
    }
     
    func makeMockTestView(state: MockTestState) -> TestBoardView {
        let presenter = TestViewPresenter(state: state,
            actionDispatcher: store, storeSensorCollectionUseCaseFactory: self,
            createAssessmentUseCaseFactory: self,
            updateFeedbackUseCaseFactory: self)
        let view  = TestBoardView(store: presenter)
        return view
    }
    
    func sensorDetailView() {
        
    }
    
    func makeAssessmentListView(state: AssessmentListState) -> AssessmentListView {
        let testBoardFactory = { state in
            return self.makeMockTestView(state: state)
        }
        
        let presenter = AssessmentListPresenter(state: state,
                                                  candidate: candidate,
                                                  actionDispatcher: store,
                                                  testBoardViewFactory: testBoardFactory,
                                                  fetchAssessmentUseCaseFactory: self)
        let view = AssessmentListView(store: presenter)
        
        return view
    }
    
}

extension DriverSenseCandidateContainer: FetchAssessmentUseCaseFactory {
    
    func makeFetchAssessmentUseCase(candidate: CandidatesModel, page: Int) -> UseCase {

         let useCase = FetchAssessmentUseCase(assessmentDataLayer: dataLayer,
                                              candidate: candidate, page: page,
                                              actionDispatcher: store)
        return useCase
    }
    
}

extension DriverSenseCandidateContainer: StoreSensorDataUseCaseFactory {
    
    func makeStoreSensorDateUseCase(forAssessment: AssessmentModel) -> UseCase {
       
        let useCase = StoreSensorDataUseCase(assessmentDataLayer: dataLayer,
                                             forAssessment: forAssessment,
                                             actionDispatcher: store,
                                             sensorDataProvider: sensorDataProvider)
        return useCase
    }
    
}

extension DriverSenseCandidateContainer: UpdateFeedbackUseCaseFactory {
    
    func makeUpdateFeedbackUseCase(feedback: FeedbackModel,
                                   forAssessment: AssessmentModel) -> UseCase {
        let userCase =  UpdateFeedBackUseCase(assessmentDataLayer: dataLayer, feedback: feedback,
                                              assessment: forAssessment, actionDispatcher: store)
        return userCase
    }
    
}

extension DriverSenseCandidateContainer: CreateAssessmentUserCaseFactory {
    
    func makeCreateAssessmentUseCase(forAssessment: AssessmentModel) -> UseCase {
        let useCase = CreateAssessmentUseCase(assessmentDataLayer: dataLayer,
                                              assessment: forAssessment,
                                              actionDispatcher: store)
        return useCase
    }
    
}
