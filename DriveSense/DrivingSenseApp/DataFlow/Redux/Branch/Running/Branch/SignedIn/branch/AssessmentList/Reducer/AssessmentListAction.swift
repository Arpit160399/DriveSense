//
//  AssessmentListAction.swift
//  DriveSense
//
//  Created by Arpit Singh on 10/10/22.
//

import Foundation
struct AssessmentListAction: Action {
    
    struct PresentedError: Action {
        var error: ErrorMessage
    }
    
    struct FetchingList: Action {}
    
    struct FetchedList: Action {
        var list: [AssessmentModel]
        var page: Int
    }
    
    struct FinishedWithError: Action {
        var error: ErrorMessage
    }
    
    struct PresentSensorData: Action {
        
    }
    struct PresentMockTesting: Action {
        var candidate: CandidatesModel
    }
}
