//
//  SignedInState.swift
//  DriveSense
//
//  Created by Arpit Singh on 12/09/22.
//

import Foundation
struct SignedInState: Equatable {
    var userSession: UserSession
    var candidates: [CandidatesModel] = [CandidatesModel]()
    var isLoading: Bool = false
    var indexToScroll: Int = 0
    var currentPage: Int  = 0
    var errorToPresent = Set<ErrorMessage>()
    var candidatesViewState: CandidatesViewState
}
