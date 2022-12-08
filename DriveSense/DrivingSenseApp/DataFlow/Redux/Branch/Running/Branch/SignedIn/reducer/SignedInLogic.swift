//
//  SignedInLogic.swift
//  DriveSense
//
//  Created by Arpit Singh on 23/09/22.
//

import Foundation
struct SignedInLogic {
    static func setState(state: SignedInState, action: Action) -> SignedInState {
        var state = state
        switch action {
        case _ as SignedInAction.AddNewCandidate:
            state.candidatesViewState = .addCandidate(.init(loading: false,
                                                            candidate: .init()))
            
        case let action as SignedInAction.FetchedCandidateList:
            state.candidates.append(contentsOf: action.list)
            state.currentPage = action.forPage
            state.isLoading = false
            
        case let action as SignedInAction.searchForCandidateBy:
            state.searchText = action.name
            state.candidates.append(contentsOf: action.candidates)
            state.currentPage = action.pageNumber
            state.isLoading = false
            
        case let action as SignedInAction.PresentAssessmentDetail:
            state.candidatesViewState = .assessmentDetail(.init(candidate: action.forCandidate))
            
        case let action as SignedInAction.PresentSettings:
            state.candidatesViewState = .Setting(.init(enableSensorDataCollection: action.toggleState))
            
        case let action as SignedInAction.FetchingCandidateList:
            if let query = action.forQuery {
                state.searchText = query
                state.candidates = []
            } else {
                state.searchText = ""
            }
            state.isLoading = true
        case let action as SignedInAction.FinishedCandidateFetchingWithError:
            state.errorToPresent.insert(action.error)
            
        case let action as SignedInAction.PresentedCandiateFetchingError:
            state.errorToPresent.remove(action.error)
            state.isLoading = false
            
        default:
            break
        }
        return state
    }
}
