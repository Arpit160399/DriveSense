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
        
        switch state {
             case .OnBoarding(let onBoardingState):
             state = .OnBoarding(ReducerCollection.OnboardingReducer(onBoardingState,action))
            default:
              break
         }
        
         switch action {
           case _ as AppRunningAction.SignOut:
             state = .OnBoarding(.login(LoginState()))
           case let action as LoginAction.SignInCompleted:
             state = RunningState.SignIn(SignedInState(userSession: action.user,
                                         candidatesViewState: CandidatesViewState.presentCandidateList))
           default:
                break
          }
        
        return state
    }
}
