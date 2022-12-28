//
//  UserVerification.swift
//  DriveSense
//
//  Created by Arpit Singh on 12/09/22.
//

import Foundation
import Combine
class UserVerification: UseCase {

    private var task = Set<AnyCancellable>()
    let remoteApi: InstructorRemoteApi
    let session: UserSession
    let actionDispatcher: ActionDispatcher
    
    init(remoteApi: InstructorRemoteApi,
         userSession: UserSession,
         dispatcher: ActionDispatcher) {
        self.remoteApi = remoteApi
        self.session = userSession
        self.actionDispatcher = dispatcher
    }
    
    func start() {
        remoteApi.getUser().sink(receiveCompletion: { completion in
            if case .failure(let error) = completion {
                self.present(error: error)
            }
         },receiveValue: finishedVerifying(user:))
            .store(in: &task)
    }
    
    func finishedVerifying(user: InstructorModel) {
        let newSession = session
        newSession.user = user
        let authSate = AuthenticationState.signedIn(newSession)
        let action = LaunchingAction.FinishedLaunching(authenticationState: authSate)
        actionDispatcher.dispatch(action)
    }
    
    func present(error: Error) {
        let errorMessage = ErrorMessage(title: "Sign In Error",
                                        message: "Sorry, your session expired.\nPlease sign in again.")
        let action = LaunchingAction.FinishedWithAppError(error: errorMessage)
        actionDispatcher.dispatch(action)
    }
}

protocol UserVerificationCaseFactory {
    func makeUserVerificationUseCase(user: UserSession) -> UseCase
}
