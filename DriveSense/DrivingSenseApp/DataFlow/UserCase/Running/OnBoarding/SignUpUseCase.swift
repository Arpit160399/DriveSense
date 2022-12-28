//
//  SignUpUseCase.swift
//  DriveSense
//
//  Created by Arpit Singh on 13/09/22.
//
import Combine
import Foundation
class SignUpUseCase: UseCase {

    private var task = Set<AnyCancellable>()
    var userDataLayer: UserDataLayer
    var newInstructor: InstructorModel
    let actionDispatcher: ActionDispatcher
    
    init(userDataLayer: UserDataLayer,
         dispatcher: ActionDispatcher,
         newInstructor: InstructorModel) {
        self.userDataLayer = userDataLayer
        self.newInstructor = newInstructor
        self.actionDispatcher = dispatcher
    }

    func start() {
        let action = RegisterAction.RegisterInProgress()
        newInstructor.createdAt = Date().timeIntervalSince1970
        actionDispatcher.dispatch(action)
             userDataLayer
            .register(asInstructor: newInstructor)
            .sink { completion in
                if case .failure(let error) = completion {
                    var errorMessage = ErrorMessage(title: "Failed to Register",
                                                    message: "Please check your enter the correct \n details in below field")
                    if case NetworkError.serverWith(let repose) = error {
                        errorMessage.message = repose.message
                    }
                    self.present(error: errorMessage)
                }
            } receiveValue: { session in
                let action = RegisterAction.RegisterCompleted(user: session)
                self.actionDispatcher.dispatch(action)
            }
            .store(in: &task)
    }
    
    func present(error: ErrorMessage) {
        let action = RegisterAction.RegistrationFailedWithError(error: error)
        actionDispatcher.dispatch(action)
    }
    
}

struct SignInUser {
    var email = ""
    var password = ""
}


protocol SignUpUseCaseFactory {
    func makeSignUpUseCase(newInstructor: InstructorModel) -> UseCase
}


