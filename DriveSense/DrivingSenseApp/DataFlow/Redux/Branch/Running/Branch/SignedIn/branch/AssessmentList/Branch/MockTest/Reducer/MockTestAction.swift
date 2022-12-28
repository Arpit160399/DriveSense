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
    
    struct UpdateFeedBackLocal: Action {
        var feedback: FeedbackModel
    }
    
    struct UpdateCurrentUserCase: Action {
        var sensorTask: UseCase
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
