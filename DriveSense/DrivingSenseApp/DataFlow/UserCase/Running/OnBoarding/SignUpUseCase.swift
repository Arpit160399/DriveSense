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
    var remoteApi: AuthRemoteAPI
    var newInstructor: InstructorModel
    let actionDispatcher: ActionDispatcher
    private var instuctorCaching: CacheInstructorModel?
    
    init(remoteApi: AuthRemoteAPI,
         dispatcher: ActionDispatcher,
         newInstructor: InstructorModel) {
        self.remoteApi = remoteApi
        self.newInstructor = newInstructor
        self.actionDispatcher = dispatcher
        let localStore = CoreDataInstructorPersistencelayer()
        self.instuctorCaching = CacheInstructorModel(localStore: localStore,
                                                     delegate: self)
    }

    
    func start() {
        let action = RegisterAction.RegisterInProgress()
        actionDispatcher.dispatch(action)
            remoteApi.registration(as: newInstructor)
            .map({ session in
                self.instuctorCaching?.saveInstructor(model: session.user)
                return session
            })
            .sink { completion in
                if case .failure(let error) = completion {
                    var errorMessage = ErrorMessage(title: "Failed to Register",
                                                    message: "Please check your enter the correct \n details in below field")
                    if case NetworkError.ServerWith(let repose) = error {
                        print(repose)
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

extension SignUpUseCase: CachingCompletionHandler {
    func cachingFinished<T>(res: T?) where T : Equatable {
    }
    
   
    func cachingFinished(WithError: Error) {
        present(error: ErrorMessage(title: "Error happpend in caching", message: "unable to \nsave into local db"))
    }
    
}



struct SignInUser {
    var email = ""
    var password = ""
}


protocol SignUpUseCaseFactory {
    func makeSignUpUseCase(newInstructor: InstructorModel) -> UseCase
}


