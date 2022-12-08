//
//  MockTestAction.swift
//  DriveSense
//
//  Created by Arpit Singh on 13/10/22.
//

import Foundation
struct MockTestAction: Action {
    
    struct updateAssessment: Action {
        var assessment: AssessmentModel
    }
    
    struct DismissTestBoard: Action {
        var feedback: FeedbackModel
    }
    
    struct generatingAssessment: Action {}
    
    struct PresentTestBoard: Action {}
    
    struct MockTestError: Action {
        var error: ErrorMessage
    }
    
    struct PresentedError: Action {
        var error: ErrorMessage
    }
}
