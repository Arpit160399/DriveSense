//
//  LoginView.swift
//  DriveSense
//
//  Created by Arpit Singh on 30/07/22.
//

import Foundation
class LoginViewPresenter: ObservableObject {
    @Published var email: String  = ""
    @Published var password: Secret = ""
    @Published var showError = false
    
    @Published var state: LoginState
    let makeSignInUserCaseFactory: SignInUseCaseFactory
    let actionDispatcher: ActionDispatcher
   
    init(store: LoginState,
         makeSignInUserCaseFactory: SignInUseCaseFactory,
         dispatcher: ActionDispatcher) {
        self.state = store
        self.makeSignInUserCaseFactory = makeSignInUserCaseFactory
//        self.stateGetter = stateGetter
        self.actionDispatcher = dispatcher
        showError = !state.errorsToShow.isEmpty
    }
    
    //MARK: perfrom Login Action
    func loginUser() {
        let userCase = makeSignInUserCaseFactory.makeSignInUseCaseFactory(email: email, password: password)
        userCase.start()
    }
    
    func send(action: Action) {
        actionDispatcher.dispatch(action)
    }
    
}

