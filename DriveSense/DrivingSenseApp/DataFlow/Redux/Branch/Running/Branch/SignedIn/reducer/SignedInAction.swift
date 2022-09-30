//
//  SignedInAction.swift
//  DriveSense
//
//  Created by Arpit Singh on 22/09/22.
//

import Foundation
struct SignedInAction: Action {
    
    struct AddNewCandidate: Action {}
    
    struct FetchingCandidateList: Action {}
    
    struct PresentCandidateDetail: Action {
        let forCandidate: CandidatesModel
    }
    
    struct FinishedCandidateFetchingWithError: Action {
        let error: ErrorMessage
    }
    
    struct PresentedCandiateFetchingError: Action {
        let error: ErrorMessage
    }
    
    struct FetchedCandidateList: Action {
        let list: [CandidatesModel]
        let forPage: Int
    }
}
