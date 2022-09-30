//
//  DriverSenseSignedInContainer.swift
//  DriveSense
//
//  Created by Arpit Singh on 23/09/22.
//

import Foundation
class DriverSenseSignedInContainer {
    
    let store: Store<AppState>
    private let useSession: UserSession
    
    init(mainContainer: DriverSenseContainer,
         session: UserSession) {
        self.store = mainContainer.store
        self.useSession = session
    }
    
    func makeCandidateListView(state: SignedInState) -> CandidateList {
        let presenter = CandidateListPresenter(state: state,
                                               actionDispatcher: store,
                                               fetchCandidateListFactory: self)
        let view = CandidateList(store: presenter)
        return view
    }
    
//    func makeCandidateDetailView(stat)
    
    
}

extension DriverSenseSignedInContainer: FetchCandidateUseCaseFactory {
    
    func makeFetchCandidateUseCase(pageNumber: Int) -> UseCase {
        let remoteApi = DriveSenseUserRemoteApi(userSession: useSession)
        let useCase = FetchCandidateUseCase(remoteApi: remoteApi, actionDispatcher: store, page: pageNumber)
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
