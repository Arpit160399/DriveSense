//
//  LoginReducer.swift
//  DriveSense
//
//  Created by Arpit Singh on 13/09/22.
//

import Foundation

extension ReducerCollection {
    
    static let LoginReducer: Reducer<LoginState> = { state , action in
          var state = state
           switch action {
               case let action as LoginAction.SignInOnProgress:
               LoginLogic.signInOnProgress(for: &state.viewState)
               case let action as LoginAction.SignInErrorPresented:
               LoginLogic.finishedWithAnError(for: &state.viewState)
               state.errorsToShow.remove(action.error)
               case let action as LoginAction.SignInFailedWithError:
                state.errorsToShow.insert(action.error)
              default:
                   break
          }
          return state
    }
    
}
