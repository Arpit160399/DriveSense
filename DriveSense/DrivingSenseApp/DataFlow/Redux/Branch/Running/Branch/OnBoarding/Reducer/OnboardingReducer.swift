//
//  OnboardingReducer.swift
//  DriveSense
//
//  Created by Arpit Singh on 13/09/22.
//

import Foundation

extension ReducerCollection {
    
    static let OnboardingReducer: Reducer<OnBoardingState> = { state , action  in
        var state = state
        switch action {
          case _ as OnBoardingActions.goToSignIn:
            state = .login(LoginState())
          case _ as OnBoardingActions.goToSignUp:
            state = .register(RegisterState())
         default:
            break
       }
        switch state {
        case .login(let loginState):
            state = .login(ReducerCollection.LoginReducer(loginState,action))
        case .register(let registerState):
            state = .register(ReducerCollection.RegisterReducer(registerState,action))
        }
        return state
    }
    
}
