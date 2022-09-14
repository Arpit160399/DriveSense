//
//  DriverSenseOnBoardingContainer.swift
//  DriveSense
//
//  Created by Arpit Singh on 13/09/22.
//

import Foundation
class DriverSenseOnBoardingContainer {
    let store: Store<AppState>
    let appRunningGetter: AppStateGetter
    
    init(mainContainer: DriverSenseContainer) {
        self.store = mainContainer.store
        self.appRunningGetter = mainContainer.stateGetter
    }
    
    func makeOnBoarding() -> UserOnBoarding {
    }
    
    func makeLoginInView() -> Login {}
    
    func makeRegisterView() -> Registration {}
}

extension DriverSenseOnBoardingContainer: SignInUseCaseFactory {
    func makeSignInUseCaseFactory(email: String, password: Secret) -> UseCase {
        let remoteApi = DriveSenseRemoteAuth()
        let userCase = SignInUseCase(email: email, password: password,
                                     dispatcher: store, remoteApi: remoteApi)
        return userCase
    }
}
