//
//  DriverSenseContainer.swift
//  DriveSense
//
//  Created by Arpit Singh on 22/08/22.
//

import SwiftUI
import Combine


class DriverSenseContainer {
        
    // MARK: - Properties
    let userSessionManager: UserSessionManager
    let store : Store<AppState>
    let stateGetter: AppStateGetter

    // MARK: - Methods
    init() {
        let userSessionCoder = UserSessionPropertyListCoding()
        userSessionManager = KeychainUserSessionDataStore(coder: userSessionCoder)
        let initialState = AppState.launching(.init())
        self.store = Store(initial: initialState,
                           reducer: ReducerCollection.appReducer,
                           middlewares: [])
        stateGetter = AppStateGetter()
    }
    
    
    // Main Screen
    public func makeMainView() -> MainView {
        let onBoardingFactory = { (state: OnBoardingState) in
            return self.makeOnBoardingContainer()
                .makeOnBoarding(state: state)
        }
        
        let signedInFactory = { (state: SignedInState) in
            return self.makeSignedInContainer(userSession: state.userSession)
                .makeCandidateListView(state: state)
        }
        
        let presenter = MainViewPresenter(store: store,
                        onBoardingFactory: onBoardingFactory,
                        signedInFactory: signedInFactory,
                        loadUsersSessionFactory: self,
                        verifyUserUseCaseFactory: self,
                        stateGetter: stateGetter)
        let mainView = MainView(dispatcher: presenter)
        return mainView
    }
    
    // OnBoarding Container Factory
    public func makeOnBoardingContainer() -> DriverSenseOnBoardingContainer {
        let container = DriverSenseOnBoardingContainer(mainContainer: self, runningStateGetter: RunningStateGetter(stateGetter.getAppRunningState(appState:)))
        return container
    }
    
    
    // SignedIn Container Factory
    public func makeSignedInContainer(userSession: UserSession) -> DriverSenseSignedInContainer {
       let container = DriverSenseSignedInContainer(mainContainer: self,
                                                    session: userSession)
        return container
    }
    
}

extension DriverSenseContainer: LoadUserAuthenticationFactory {
    func makeLoadUserAuthenticationUseCase() -> UseCase {
        let sessionLoader = LoadUserAuthentication(sessionManager: userSessionManager,
          dispatcher: store)
        return sessionLoader
    }
}

extension DriverSenseContainer: UserVerificationCaseFactory {
    
    func makeUserVerificationUseCase(user: UserSession) -> UseCase {
        let userRemoteApi = DriveSenseUserRemoteApi(userSession: user)
        let useCase = UserVerification(remoteApi: userRemoteApi
                                       , userSession: user,
                                       dispatcher: store)
        
        return useCase
    }
    
}
