//
//  LoginReducer.swift
//  DriveSense
//
//  Created by Arpit Singh on 13/09/22.
//

import Foundation
struct LoginLogic {
    
    static func signInOnProgress(for state: inout LoginStateView) {
        state.isEmailInputEnable = false
        state.isLoginButtonEnable = false
        state.isPasswordEnable = false
        state.isLoading = true
    }
    
    static func finishedWithAnError(for state: inout LoginStateView) {
        state.isLoading = false
        state.isEmailInputEnable = true
        state.isLoginButtonEnable = true
        state.isPasswordEnable = true
    }
    
}

extension ReducerCollection {
    
    static let LoginReducer: Reducer<LoginState> = { state , action in
          var state = state
           switch action {
               case let action as LoginAction.SignInOnProgress:
               LoginLogic.signInOnProgress(for: &state.viewState)
               case let action as LoginAction.SignInErrorPresented:
               LoginLogic.signInOnProgress(for: &state.viewState)
               case let action as LoginAction.SignInFailedWithError:
                state.errorsToShow.insert(action.error)
              default:
                   break
          }
          return state
    }
    
}
