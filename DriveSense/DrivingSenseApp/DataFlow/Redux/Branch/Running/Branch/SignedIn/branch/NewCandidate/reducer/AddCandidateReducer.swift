//
//  AddCandidateReducer.swift
//  DriveSense
//
//  Created by Arpit Singh on 21/09/22.
//

import Foundation
extension ReducerCollection {
    static let AddCandidateReducer: Reducer<AddCandidateState> = { state, action in
        var state = state
        switch action {
        case let action as AddCandidateAction.EnrollInProgress:
            state.loading = true
            state.candidate = .init(model: action.candidate)
        case let action as AddCandidateAction.FinishedWithError:
            state.errorToPresent.insert(action.error)
        case let action as AddCandidateAction.PresentedError:
            state.errorToPresent.remove(action.error)
        default:
            break
        }
        return state
    }
}
