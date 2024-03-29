//
//  MockTestAction.swift
//  DriveSense
//
//  Created by Arpit Singh on 13/10/22.
//

import Foundation
struct MockTestAction: Action {
    
    struct UpdateAssessment: Action {
        var assessment: AssessmentModel
    }
    
    struct AcceptedPolicy: Action {}
    
    struct DismissTestBoard: Action {
        var feedback: FeedbackModel
    }
    
    struct UpdatingFeedbackLocal: Action {}
    
    struct UpdateFeedBackState: Action {
        var feedback: FeedbackModel
    }
    
    struct UpdatedFeedBackLocal: Action {
        var feedback: FeedbackModel
    }
    
    struct UpdatedDrivingState: Action {
        var speed: Double
        var distance: Double
        var direction: String
    }
    
    struct GeneratingAssessment: Action {}
    
    struct PresentTestBoard: Action {}
    
    struct MockTestError: Action {
        var error: ErrorMessage
    }
    
    struct PresentedError: Action {
        var error: ErrorMessage
    }
}
