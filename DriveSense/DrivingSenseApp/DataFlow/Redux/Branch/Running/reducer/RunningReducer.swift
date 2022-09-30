//
//  RunningReducer.swift
//  DriveSense
//
//  Created by Arpit Singh on 09/09/22.
//

import Foundation
extension ReducerCollection {
    
    static let runningReducer: Reducer<RunningState> = { state , action in
         var state = state
        
        switch action {
          case _ as AppRunningAction.SignOut:
            state = .OnBoarding(.login(LoginState()))
          case let action as OnBoardingCompeted:
            state = RunningState.SignIn(SignedInState(userSession: action.user,
                                                      candidatesViewState: .candidateList))
          default:
               break
         }
        
        switch state {
             case .OnBoarding(let onBoardingState):
             state = .OnBoarding(ReducerCollection.OnboardingReducer(onBoardingState,action))
             case .SignIn(let signState):
             state = .SignIn(ReducerCollection.SignInReducer(signState, action))
         }
        
        return state
    }
}
