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
            state = .onBoarding(.login(LoginState()))
          case let action as OnBoardingCompeted:
            state = RunningState.signIn(SignedInState(userSession: action.user,
                                                      candidatesViewState: .candidateList))
          default:
               break
         }
        
        switch state {
             case .onBoarding(let onBoardingState):
             state = .onBoarding(ReducerCollection.OnboardingReducer(onBoardingState,action))
             case .signIn(let signState):
             state = .signIn(ReducerCollection.SignInReducer(signState, action))
         }
        
        return state
    }
}
