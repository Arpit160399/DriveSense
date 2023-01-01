//
//  AssessmentList.swift
//  DriveSense
//
//  Created by Arpit Singh on 10/10/22.
//

import Foundation

struct AssessmentListState: Equatable {
    var loading: Bool
    var page: Int
    var cloudSyncState: AssessmentSyncOperation = .begin
    var candidate: CandidatesModel
    var assessment: Set<AssessmentModel>
    var viewState: AssessmentViewState
    var errorPresenter = Set<ErrorMessage>()
     
    init(candidate: CandidatesModel,errorPresenter: Set<ErrorMessage> = Set<ErrorMessage>()) {
        self.loading = false
        self.page = 0
        self.candidate = candidate
        self.assessment = Set<AssessmentModel>()
        self.viewState = .list
        self.errorPresenter = errorPresenter
    }
    
}

enum AssessmentSyncOperation: Equatable {
    case begin
    case inProgress
    case end
}

enum AssessmentViewState: Equatable {
    case list
    case mockTest(MockTestState)
    case assessmentDetail(AssessmentDetailState)
}
