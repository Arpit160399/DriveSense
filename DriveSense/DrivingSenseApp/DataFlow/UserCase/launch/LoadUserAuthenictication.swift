//
//  LoadUserAuthenictication.swift
//  DriveSense
//
//  Created by Arpit Singh on 09/09/22.
//
import Combine
import Foundation
class LoadUserAuthentication: UseCase {
    
    private var task = Set<AnyCancellable>()
    let userSessionManager: UserSessionManager
    let actionDispatcher: ActionDispatcher
    
    init(sessionManager: UserSessionManager,
         dispatcher: ActionDispatcher) {
        self.actionDispatcher = dispatcher
        self.userSessionManager = sessionManager
    }
    
    func start() {
        userSessionManager.getUser()
            .sink(receiveCompletion: {  completed in
                if case .failure(let error) = completed {
                    self.present(error: error)
                }
            }, receiveValue: finishedLaunching(with: ))
            .store(in: &task)
    }
    
    func finishedLaunching(with session: UserSession?) {
        let auth = AuthenticationState(session: session)
        let action = LaunchingAction.FinishedLaunching(authenticationState: auth)
        actionDispatcher.dispatch(action)
    }
    
    func present(error: Error) {
        let errorMessage = ErrorMessage(title: "Sign In Error",
                                        message: "Sorry, we couldn't determine if you are already signed in.\nPlease sign in or sign up.")
        let action = LaunchingAction.FinishedWithAppError(error: errorMessage)
        actionDispatcher.dispatch(action)
    }
}

protocol LoadUserAuthenticationFactory {
    func makeLoadUserAuthenticationUseCase() -> UseCase
}
