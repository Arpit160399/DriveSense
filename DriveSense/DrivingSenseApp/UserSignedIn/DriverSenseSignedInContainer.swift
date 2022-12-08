//
//  DriverSenseSignedInContainer.swift
//  DriveSense
//
//  Created by Arpit Singh on 23/09/22.
//

import Foundation
class DriverSenseSignedInContainer {
    
    //MARK: -  property
    let store: Store<AppState>
    let useSession: UserSession
    let sensorHandler: SensorHandler
    private let userSessionManager: UserSessionManager
    // MARK: - Methods
    init(mainContainer: DriverSenseContainer,
         session: UserSession) {
        self.store = mainContainer.store
        self.userSessionManager = mainContainer.userSessionManager
        self.useSession = session
        self.sensorHandler = mainContainer.sensorDataProvider
    }
    
    func makeCandidateListView(state: SignedInState) -> CandidateList {
        let addCandidateViewFactory = { (state: AddCandidateState) in
            return self.makeAddCandidateView(state: state)
        }
        let settingViewFactory = { (state: SettingsState) in
            return self.makeSettingsView(state: state)
        }
        
        let assessmentDetailFactory = { (state: AssessmentListState,candidate: CandidatesModel) in
            return self.makeDriverSenseCandidateContainerFor(candidate: candidate)
                .makeAssessmentDetailView(state: state)
        }
        
        let presenter = CandidateListPresenter(state: state,
                                               actionDispatcher: store,
                                               addCandidateFactory: addCandidateViewFactory,
                                               settingsViewFactory: settingViewFactory,
                                               assessmentDetailFactory: assessmentDetailFactory,
                                               fetchCandidateListFactory: self,
                                               searchCandidateUserCaseFactory: self)
        let view = CandidateList(store: presenter)
        return view
    }
    
    func makeAddCandidateView(state: AddCandidateState) -> AddCandidateView {
        let presenter = AddCandidatePresenter(state: state,
                                              makeEnrollCandidateUseCaseFactory: self,
                                              actionDispatcher: store)
        let view = AddCandidateView(store: presenter)
        return view
    }
    
    func makeSettingsView(state: SettingsState) -> SettingsView {
        let presenter = SettingsPresenter(state: state,
                                          user: useSession.user,
                                          actionDispatcher: store,
                                          signoutUseCseFactory: self)
        let view = SettingsView(store: presenter)
        return view
    }

    private func makeDriverSenseCandidateContainerFor(candidate: CandidatesModel) -> DriverSenseCandidateContainer {
         return DriverSenseCandidateContainer(container: self, candidate: candidate)
    }
    
}

extension DriverSenseSignedInContainer: FetchCandidateUseCaseFactory {
    
    func makeFetchCandidateUseCase(pageNumber: Int) -> UseCase {
        let remoteApi = DriveSenseUserRemoteApi(userSession: useSession)
        let useCase = FetchCandidateUseCase(remoteApi: remoteApi, actionDispatcher: store, page: pageNumber)
        return useCase
    }
    
}

extension DriverSenseSignedInContainer: SearchForCandidateUseCaseFactory {
    
    func makeSearchForCandidateUserCase(query: String, page: Int) -> UseCase {
        let remoteApi = DriveSenseUserRemoteApi(userSession: useSession)
        let useCase = SearchForCandidateUseCase(query: query,
                      actionDispatcher: store, page: page,
                      remoteAPi: remoteApi)
        return useCase
    }
        
}

extension DriverSenseSignedInContainer: EnrollNewCandidateFactory {

    func makeEnrollNewCandidateUseCase(candidate: CandidatesModel) -> UseCase {
        let remoteApi = DriveSenseUserRemoteApi(userSession: useSession)
        let useCase = EnrollNewCandidates(actionDispatcher: store,
                      candidate: candidate, remoteApi: remoteApi)
        return useCase
    }
}

extension DriverSenseSignedInContainer: SignoutUsecaseFactory {
    
    func makeSignoutUseCase() -> UseCase {
        let useCase = SignoutUsecase(userSessionManager: userSessionManager,
                                     actionDispatcher: store)
        return useCase
    }
    
}
