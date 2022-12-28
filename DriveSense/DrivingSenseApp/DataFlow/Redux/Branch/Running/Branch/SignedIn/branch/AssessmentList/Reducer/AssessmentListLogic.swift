//
//  AssessmentListLogic.swift
//  DriveSense
//
//  Created by Arpit Singh on 11/10/22.
//

import Foundation
struct AssessmentListLogic {
    static func setState(current: AssessmentListState, action: Action) -> AssessmentListState {
        var state = current
        let listLimit = 200
        switch action {
        case let action as AssessmentListAction.FetchedList:
            state.page = action.page
            if state.assessment.count < listLimit {
                action.list.forEach({ state.assessment.insert($0) })
            }
            state.loading = false
        case _ as AssessmentListAction.FetchingList:
            state.loading = true

        case let action as AssessmentListAction.FinishedWithError:
            state.errorPresenter.insert(action.error)

        case let action as AssessmentListAction.FinishedWithError:
            state.errorPresenter.remove(action.error)
            state.loading = false

        default:
            break
        }
        return state
    }
}
