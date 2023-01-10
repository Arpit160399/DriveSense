//
//  AssessmentListReducer.swift
//  DriveSense
//
//  Created by Arpit Singh on 10/10/22.
//

import Foundation
extension ReducerCollection {
    static let AssessmentListReducer: Reducer<AssessmentListState> = { (state, action) in
        var state = state
        switch action {
        case _ as AssessmentListAction.AssessmentListDismissView:
            state.viewState = .list
            state.cloudSyncState = .begin
        case let action as AssessmentListAction.PresentAssessmentDetail:
            state.viewState = .assessmentDetail(.init(assessment: action.assessment, places: [],
                                                      errorToPresent: Set<ErrorMessage>()))
        case let action as AssessmentListAction.PresentMockTesting:
            state.viewState = .mockTest(.init(assessment: .init(id: UUID(),
                                                                feedback: TestMark().convertToFeedbackModel()),
                                              errorToPresent: Set<ErrorMessage>(),
                                              viewState: .consentForm))
        default:
            state = AssessmentListLogic.setState(current: state, action: action)
        }
        switch state.viewState {
        case .mockTest(let mockState):
            state.viewState = .mockTest(ReducerCollection.MockTestReducer(mockState, action))
        case .assessmentDetail(let assessmentDetailState):
            state.viewState = .assessmentDetail(ReducerCollection.AssessmentDetailReducer(assessmentDetailState, action))
        default:
            break
        }
        return state
    }
}
