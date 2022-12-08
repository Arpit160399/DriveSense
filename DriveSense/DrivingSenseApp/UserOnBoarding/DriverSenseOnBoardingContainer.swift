//
//  DriverSenseOnBoardingContainer.swift
//  DriveSense
//
//  Created by Arpit Singh on 13/09/22.
//

import Foundation
class DriverSenseOnBoardingContainer {
    
    let store: Store<AppState>
    let appRunningGetter: RunningStateGetter
    
    init(mainContainer: DriverSenseContainer,
         runningStateGetter: RunningStateGetter) {
        self.store = mainContainer.store
        self.appRunningGetter = runningStateGetter
    }
    
    func makeOnBoarding(state: OnBoardingState) -> UserOnBoarding {
        let presenter = UserOnBoardingPresenter(state: state, actionDispatcher: store, loginFactory: makeLoginInView(state:), registrationFactory: makeRegisterView(state:))
        return UserOnBoarding(store: presenter)
    }
    
    func makeLoginInView(state: LoginState) -> Login {
        let presenter = LoginViewPresenter(store: state, makeSignInUserCaseFactory: self,
            dispatcher: store)
        return Login(store: presenter)
    }
    
    func makeRegisterView(state: RegisterState) -> Registration {
        let presenter = RegistrationPresenter(state: state,
                                            actionDispatcher: store,
                                            makeSignUpUseCaseFactor: self)
        return Registration(store: presenter)
    }
}

extension DriverSenseOnBoardingContainer: SignInUseCaseFactory {
    func makeSignInUseCaseFactory(email: String, password: Secret) -> UseCase {
        let remoteApi = DriveSenseRemoteAuth()
        let userCase = SignInUseCase(email: email, password: password,
                                     dispatcher: store, remoteApi: remoteApi)
        return userCase
    }
}

extension DriverSenseOnBoardingContainer: SignUpUseCaseFactory {
    
    func makeSignUpUseCase(newInstructor: InstructorModel) -> UseCase {
        let dataLayer = DataManager().getUserDataLayer()
        let userCase = SignUpUseCase(userDataLayer: dataLayer,
                                     dispatcher: store,
                                     newInstructor: newInstructor)
        return userCase
    }
    
}
