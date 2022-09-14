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
        self.store = Store(initial: .launching(LaunchingState()),
                           reducer: ReducerCollection.appReducer,
                           middlewares: [])
        stateGetter = AppStateGetter()
    }
    
    
    // Main Screen
    public func makeMainView() -> MainView {
        
        let onBoardingFactory = {
            return self.makeOnBoardingView()
        }
        
        let signedInFactory = { (userSession: UserSession) in
            return self.makeCandiateView()
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
    
    // OnBoarding Screens
    public func makeOnBoardingView() -> UserOnBoarding {
        return UserOnBoarding(currentUserNeedTo: .Login, loginViewModel: LoginViewModel(), registrationViewModel: RegistrationViewModel())
    }
    
    
    // Candiate Screen
    public func makeCandiateView() -> CandidateList {
       return CandidateList()
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
        let userRemoteApi = DriveSenseUserRemoteApi(session: user.session)
        let useCase = UserVerification(remoteApi: userRemoteApi
                                       , userSession: user,
                                       dispatcher: store)
        
        return useCase
    }
    
}
