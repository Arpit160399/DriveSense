//
//  AddCandidateAction.swift
//  DriveSense
//
//  Created by Arpit Singh on 23/09/22.
//

import Foundation
struct AddCandidateAction: Action {
    
    struct EnrollInProgress: Action {}
    
    struct successFullEnrolled: Action {
        var candidateList: [CandidatesModel]
    }
    
    struct FinishedWithError: Action {
        let error: ErrorMessage
    }
    
    struct PresentedError: Action {
        let error: ErrorMessage
    }
    
}
