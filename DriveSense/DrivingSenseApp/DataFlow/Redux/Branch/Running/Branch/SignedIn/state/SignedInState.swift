//
//  SignedInState.swift
//  DriveSense
//
//  Created by Arpit Singh on 12/09/22.
//

import Foundation
struct SignedInState: Equatable {
      
    var userSession: UserSession
    var candidatesViewState: CandidatesViewState
}
