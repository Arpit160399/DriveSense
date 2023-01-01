//
//  MockTestLogic.swift
//  DriveSense
//
//  Created by Arpit Singh on 08/11/22.
//

import Foundation
struct MockTestLogic {
    static func setState(currentState: MockTestState, action: Action) -> MockTestState {
        var state = currentState
        
        switch action {

        case let action as MockTestAction.UpdatedDrivingState:
            state.testOperation = .none
            state.currentSpeed = action.speed 
            state.currentDistance += action.distance
            state.currentDirection = action.direction
            
        case let action as MockTestAction.MockTestError:
            state.errorToPresent.insert(action.error)
            state.loading = false
            
        case let action as MockTestAction.PresentedError:
            state.errorToPresent.remove(action.error)
            state.loading = false
        
        case _ as MockTestAction.UpdatingFeedbackLocal:
            state.testOperation = .savingFeedback
            
        case let action as MockTestAction.UpdateAssessment:
            state.assessment = action.assessment
            state.testOperation = .startSensorCollection
            state.loading = false
            state.viewState = .mainBoard
            
        case let action as MockTestAction.UpdateFeedBackState:
            state.assessment.feedback = action.feedback
        
        case let action as MockTestAction.UpdatedFeedBackLocal:
            state.assessment.feedback = action.feedback
            state.testOperation = .none
            
        case let action as MockTestAction.DismissTestBoard:
            state.assessment.feedback = action.feedback
            state.viewState = .mainBoard
            
        case _ as MockTestAction.GeneratingAssessment:
            state.loading = true
             
        case _ as MockTestAction.AcceptedPolicy:
            state.viewState = .initial
            
        default:
            break
        }
        return state
    }
}
