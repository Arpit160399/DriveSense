//
//  SignoutUseCase.swift
//  DriveSense
//
//  Created by Arpit Singh on 14/10/22.
//
import Combine
import Foundation
class SignoutUsecase: UseCase {
    
    private var task = Set<AnyCancellable>()
    
    private var userSessionManager: UserSessionManager
    private var actionDispatcher: ActionDispatcher
    private var userDataLayer: UserDataLayer
    
    init(userSessionManager: UserSessionManager,
         userDataLayer: UserDataLayer,
         actionDispatcher: ActionDispatcher) {
        self.userSessionManager = userSessionManager
        self.actionDispatcher = actionDispatcher
        self.userDataLayer = userDataLayer
    }
    
    func start() {
        let action = SettingsAction.SignOutInProgress()
        actionDispatcher.dispatch(action)
        Publishers.Zip( userSessionManager
            .clearSession(),
            userDataLayer.signOut())
            .sink { completion in
                if case .failure(_) = completion {
                    let errorMg = ErrorMessage(title: "Error Occurred",
                                             message: "Unable to Process it at moment")
                    let action = SettingsAction.FinishedWithError(error: errorMg)
                    self.actionDispatcher.dispatch(action)
                }
            } receiveValue: { _ in 
                let action = AppRunningAction.SignOut()
                self.actionDispatcher.dispatch(action)
            }.store(in: &task)
    }
    
}
protocol SignoutUsecaseFactory {
    func makeSignoutUseCase() -> UseCase
}
