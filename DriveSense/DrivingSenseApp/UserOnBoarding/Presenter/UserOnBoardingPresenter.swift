//
//  UserOnBoarding.swift
//  DriveSense
//
//  Created by Arpit Singh on 15/09/22.
//
import SwiftUI
import Foundation
class UserOnBoardingPresenter: ObservableObject {
      
    @Published var state: OnBoardingState
    let actionDispatcher: ActionDispatcher
    @Published var childView: AnyView? = nil
    
    let loginFactory: (LoginState) -> Login
    let registrationFactory: (RegisterState) -> Registration
    
    init(state: OnBoardingState,
         actionDispatcher: ActionDispatcher,
         loginFactory: @escaping (LoginState) -> Login,
         registrationFactory: @escaping (RegisterState) -> Registration) {
        self.registrationFactory = registrationFactory
        self.loginFactory = loginFactory
        self.state = state
        self.actionDispatcher = actionDispatcher
    }
    
    
    func getCurrentView() -> AnyView {
            switch state {
            case .login(let loginState):
                return AnyView(loginFactory(loginState))
            case .register(let registerState):
                return AnyView(registrationFactory(registerState))
            }
    }
    
}
