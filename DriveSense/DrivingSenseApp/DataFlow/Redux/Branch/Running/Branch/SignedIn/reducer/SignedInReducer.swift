//
//  SignedInReducer.swift
//  DriveSense
//
//  Created by Arpit Singh on 15/09/22.
//

import Foundation
extension ReducerCollection {
    
    static let SignInReducer: Reducer<SignedInState> = { state , action in
        var state = state
        switch action {
            
         case let action as AddCandidateAction.successFullEnrolled:
            state.candidates = action.candidateList
            state.currentPage = 0
            state.candidatesViewState = .candidateList
            
        case _ as SignedInAction.DismissCurrentView:
            state.candidatesViewState = .candidateList
            
         default:
            state = SignedInLogic.setState(state: state, action: action)
        }
        
        switch state.candidatesViewState {
            
        case .Setting(let settingState):
            state.candidatesViewState = .Setting(ReducerCollection.SettingReducer(settingState,action))
            
         case  .addCandidate(let addCandidateState):
            state.candidatesViewState = .addCandidate(ReducerCollection.AddCandidateReducer(addCandidateState,action))
            
         case  .assessmentDetail(let assessmentState):
            state.candidatesViewState = .assessmentDetail(ReducerCollection.AssessmentListReducer(assessmentState,action))
         default:
             break
       }
        return state
    }
     
}
