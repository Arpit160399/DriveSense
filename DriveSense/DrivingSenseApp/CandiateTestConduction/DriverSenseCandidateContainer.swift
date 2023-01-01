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
    
    // MARK: - Methods
    
    init(container: DriverSenseSignedInContainer,candidate: CandidatesModel) {
        self.store = container.store
        self.userSession = container.useSession
        self.candidate = candidate
        self.sensorDataProvider = container.sensorHandler
    }
     
    func makeMockTestView(state: MockTestState) -> TestBoardView {
        let mockTestDataCleanUpFactory = {
            self.sensorDataProvider.stopCollection()
        }
        
        let presenter = TestViewPresenter(state: state,
            actionDispatcher: store,
            storeSensorCollectionUseCaseFactory: self,
            createAssessmentUseCaseFactory: self,
            updateFeedbackUseCaseFactory: self,
            endTestCleanUpFactory: mockTestDataCleanUpFactory)
        let view  = TestBoardView(store: presenter)
        return view
    }
    
    func makeAssessmentDetailView(state: AssessmentDetailState) -> AssessmentDetailView {
        let presenter = AssessmentDetailPresenter(dispatcher: store,
                                                  state: state,
                                                  fetchSensorDataUserCaseFactory: self)
        return AssessmentDetailView(store: presenter)
    }
    
    func makeAssessmentListView(state: AssessmentListState) -> AssessmentListView {
        let testBoardFactory = { state in
            return self.makeMockTestView(state: state)
        }
        
        let assessmentDetailViewFactory = { state in
            return self.makeAssessmentDetailView(state: state)
        }
        
        let presenter = AssessmentListPresenter(state: state,
                                                  candidate: candidate,
                                                  actionDispatcher: store,
                                                  testBoardViewFactory: testBoardFactory,
                                                assessmentDetailViewFactory: assessmentDetailViewFactory,
                                                fetchAssessmentUseCaseFactory: self,
                                                cloudSyncAssessmentUseCaseFactory: self)
        let view = AssessmentListView(store: presenter)
        
        return view
    }
    
}

extension DriverSenseCandidateContainer: FetchAssessmentUseCaseFactory {
    
    func makeFetchAssessmentUseCase(candidate: CandidatesModel, page: Int) -> UseCase {
        let dataLayer = DataManager().getAssessmentDataLayer(session: userSession,
                                                             candidate: candidate)
         let useCase = FetchAssessmentUseCase(assessmentDataLayer: dataLayer,
                                              candidate: candidate, page: page,
                                              actionDispatcher: store)
        return useCase
    }
    
}

extension DriverSenseCandidateContainer: CloudSyncAssessmentUseCaseFactory {
    
    func makeCloudSyncAssessmentUseCase(candidate: CandidatesModel) -> UseCase {
        let dataLayer = DataManager().getAssessmentDataLayer(session: userSession,
                                                             candidate: candidate)
         let useCase = CloudSyncAssessmentUseCase(assessmentDataLayer: dataLayer,
                                              candidate: candidate,
                                              actionDispatcher: store)
        return useCase
    }
}

extension DriverSenseCandidateContainer: StoreSensorDataUseCaseFactory {
    
    func makeStoreSensorDateUseCase(forAssessment: AssessmentModel) -> UseCase {
        let dataLayer = DataManager().getAssessmentDataLayer(session: userSession,
                                                             candidate: candidate)
        let useCase = StoreSensorDataUseCase(assessmentDataLayer: dataLayer,
                                             forAssessment: forAssessment,
                                             actionDispatcher: store,
                                             sensorDataProvider: self.sensorDataProvider)
        return useCase
    }
    
}

extension DriverSenseCandidateContainer: UpdateFeedbackUseCaseFactory {
    
    func makeUpdateFeedbackUseCase(feedback: FeedbackModel,
                                   forAssessment: AssessmentModel) -> UseCase {
        let dataLayer = DataManager().getAssessmentDataLayer(session: userSession,
                                                             candidate: candidate)
        let userCase =  UpdateFeedBackUseCase(assessmentDataLayer: dataLayer, feedback: feedback,
                                              assessment: forAssessment, actionDispatcher: store)
        return userCase
    }
    
}

extension DriverSenseCandidateContainer: CreateAssessmentUserCaseFactory {
    
    func makeCreateAssessmentUseCase(forAssessment: AssessmentModel) -> UseCase {
        let dataLayer = DataManager().getAssessmentDataLayer(session: userSession,
                                                             candidate: candidate)
        let useCase = CreateAssessmentUseCase(assessmentDataLayer: dataLayer,
                                              assessment: forAssessment,
                                              actionDispatcher: store)
        return useCase
    }
    
}

extension DriverSenseCandidateContainer: FetchSensorDataUseCaseFactory {
    
    func makeFetchSensorDataUseCase(forAssessment: AssessmentModel) -> UseCase {
        let remoteApi = DataManager().getSensorDataLayer(session: userSession,
                                                         assessment: forAssessment)
        let useCase = FetchSensorDataUseCase(dispatcher: store,
                                             remoteApi: remoteApi)
        return useCase
    }
    
}
