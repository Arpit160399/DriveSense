//
//  SignedInAction.swift
//  DriveSense
//
//  Created by Arpit Singh on 22/09/22.
//

import Foundation
struct SignedInAction: Action {
    
    struct AddNewCandidate: Action {}
    
    struct SearchForCandidateBy: Action {
        var name: String
        var candidates: [CandidatesModel]
        var pageNumber: Int
    }
    
    struct FetchingCandidateList: Action {
        var forQuery: String? 
    }
    
    struct PresentAssessmentDetail: Action {
        let forCandidate: CandidatesModel
    }
    
    struct PresentMockTest:Action {
        let forCandidate: CandidatesModel
    }
    
    struct PresentSettings: Action {
        var toggleState: Bool
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
    
    struct DismissCurrentView: Action {}
}
