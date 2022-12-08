//
//  AssessmentList.swift
//  DriveSense
//
//  Created by Arpit Singh on 10/10/22.
//

import Foundation

struct AssessmentListState {
    var loading: Bool
    var page: Int
    var candidate: CandidatesModel
    var assessment: [AssessmentModel]
    var viewState: AssessmentViewState
    var errorPresenter = Set<ErrorMessage>()
     
    init(candidate: CandidatesModel,errorPresenter: Set<ErrorMessage> = Set<ErrorMessage>()) {
        self.loading = false
        self.page = 0
        self.candidate = candidate
        self.assessment = [AssessmentModel]()
        self.viewState = .list
        self.errorPresenter = errorPresenter
    }
    
}

extension AssessmentListState: Equatable {
    
    static func == (lhs: AssessmentListState, rhs: AssessmentListState) -> Bool {
        return lhs.candidate == rhs.candidate
    }
    
}

enum AssessmentViewState {
    case list
    case MockTest(MockTestState)
    case SensorData(SensorListState)
}
