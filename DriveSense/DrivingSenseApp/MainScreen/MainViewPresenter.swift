//
//  MainViewDispatcher.swift
//  DriveSense
//
//  Created by Arpit Singh on 27/08/22.
//
import SwiftUI
import Foundation
import Combine
class MainViewPresenter: ObservableObject {
    
       // MARK: - properties
    // ViewProperty
    @Published var navigation: NavigationModel = .none
    @Published var showError: Bool = false
    
    /// State
    @Published private var store: Store<AppState>
    private var task: AnyCancellable?
    
    //StateGetter
    var stateGetter: AppStateGetter
   
    // Child Views
    var onBoardingFactory: (OnBoardingState) -> UserOnBoarding
    var signedInFactory: (SignedInState) -> CandidateList

    // UserCase Factory
    var loadUsersSessionFactoryUserCase: LoadUserAuthenticationFactory
    var verifyUserUseCaseFactory: UserVerificationCaseFactory

   init(store:  Store<AppState>,
        onBoardingFactory: @escaping (OnBoardingState) -> UserOnBoarding,
        signedInFactory: @escaping (SignedInState) -> CandidateList,
        loadUsersSessionFactory: LoadUserAuthenticationFactory,
        verifyUserUseCaseFactory: UserVerificationCaseFactory,
        stateGetter: AppStateGetter) {
       self.store = store
       self.onBoardingFactory = onBoardingFactory
       self.signedInFactory = signedInFactory
       self.loadUsersSessionFactoryUserCase = loadUsersSessionFactory
       self.verifyUserUseCaseFactory = verifyUserUseCaseFactory
       self.stateGetter = stateGetter
       task = store.objectWillChange
           .receive(on: DispatchQueue.main)
           .sink(receiveValue: {
           self.setPresentingScreen()
       })
   }
    
    
   func checkForUser() {
       let userCase = loadUsersSessionFactoryUserCase
            .makeLoadUserAuthenticationUseCase()
        userCase.start()
    }
    
    private func verifyUser(session: UserSession) {
        let userCase = verifyUserUseCaseFactory
            .makeUserVerificationUseCase(user: session)
        userCase.start()
    }

    func getState() -> LaunchingState? {
        let lauchingState = stateGetter.getLaunchViewState(appState: store.state)
        guard case .value(let state) = lauchingState else {
            return nil
        }
        return state
    }
    
    func send(action: Action) {
        store.dispatch(action)
    }

    func finishedPresenting(error: ErrorMessage) {
        send(action: LaunchingAction.FinishedWithPresentError(error: error))
    }
    
    func setPresentingScreen() {
        switch store.state {
          case .running(let runningState):
            switch runningState {
                case .OnBoarding(let state):
                navigation = .init(isDisplayed: true,
                                   destination: AnyView(onBoardingFactory(state)))
                case .SignIn(let state):
                navigation = .init(isDisplayed: true,
                                   destination: AnyView(signedInFactory(state)))
             }
          case .launching(let launchState):
            if case .notVerified(let session) = launchState.currentSessionState {
                 verifyUser(session: session)
            } else if !launchState.errorPresent.isEmpty {
                showError = true
            }
        }
    }
}
