//
//  SignedInLogic.swift
//  DriveSense
//
//  Created by Arpit Singh on 23/09/22.
//

import Foundation
struct SignedInLogic {
    
    static func setState(state: SignedInState,action: Action) -> SignedInState {
        var state = state
        switch action {
        case _ as SignedInAction.AddNewCandidate:
            state.candidatesViewState = .addCandidate(.init(loading: false,
                                                    candidate: .init()))
        case let action as SignedInAction.FetchedCandidateList:
            state.candidates.append(contentsOf: action.list)
            state.currentPage = action.forPage
            state.isLoading = false
        case let action as SignedInAction.PresentCandidateDetail:
            state.candidatesViewState = .detailCandidateView
        case _ as SignedInAction.FetchingCandidateList:
            state.isLoading = true
        case let action as SignedInAction.FinishedCandidateFetchingWithError:
            state.errorToPresent.insert(action.error)
        case let action as SignedInAction.PresentedCandiateFetchingError:
            state.errorToPresent.remove(action.error)
        default:
            break
        }
        return state
    }
    
}
