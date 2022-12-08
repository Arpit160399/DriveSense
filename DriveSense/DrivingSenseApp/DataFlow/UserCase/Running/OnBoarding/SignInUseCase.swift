//
//  SignInUseCase.swift
//  DriveSense
//
//  Created by Arpit Singh on 13/09/22.
//
import Combine
import Foundation
class SignInUseCase: UseCase {
    
    private var task = Set<AnyCancellable>()
    
    let email: String
    private let password: Secret
    
    private let remoteApi: AuthRemoteAPI
    private let dispatcher: ActionDispatcher
    
    init(email: String,
         password: Secret,
         dispatcher: ActionDispatcher,
         remoteApi: AuthRemoteAPI) {
        self.email = email
        self.password = password
        self.dispatcher = dispatcher
        self.remoteApi = remoteApi
    }
    
    func start() {
        let action = LoginAction.SignInOnProgress()
        dispatcher.dispatch(action)
        remoteApi.signInRequest(for: .init(email: email, password: password))
            .sink { completion in
                if case .failure(let error) = completion {
                    var errorMessage = ErrorMessage(title: "Failed to SignIn", message: "Please check that you have enter a correct email / password.")
                    if case NetworkError.ServerWith(let response) = error {
                        errorMessage.message = response.message
                    }
                    let action = LoginAction.SignInFailedWithError(error: errorMessage)
                    self.dispatcher.dispatch(action)
                }
            } receiveValue: { userSession in
                let action = LoginAction.SignInCompleted(user: userSession)
                self.dispatcher.dispatch(action)
            }.store(in: &task)
    }
}

typealias Secret = String
protocol SignInUseCaseFactory {
    func makeSignInUseCaseFactory(email: String,password: Secret) -> UseCase
}
