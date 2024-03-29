//
//  candidatesViewState.swift
//  DriveSense
//
//  Created by Arpit Singh on 12/09/22.
//

import Foundation
enum CandidatesViewState: Equatable {
    case assessmentDetail(AssessmentListState)
    case candidateList
    case addCandidate(AddCandidateState)
    case setting(SettingsState)
}
