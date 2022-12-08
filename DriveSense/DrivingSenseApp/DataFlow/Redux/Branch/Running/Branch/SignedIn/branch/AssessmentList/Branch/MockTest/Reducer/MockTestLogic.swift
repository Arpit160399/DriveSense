//
//  MockTestLogic.swift
//  DriveSense
//
//  Created by Arpit Singh on 08/11/22.
//

import Foundation
struct MockTestLogic {
    
    static func setState(currentState: MockTestState,action:  Action) -> MockTestState {
        var state = currentState
        
        switch action {
            
            case let action as MockTestAction.MockTestError:
             state.errorToPresent.insert(action.error)
            
            case let action as MockTestAction.PresentedError:
            state.errorToPresent.remove(action.error)
              
            case let action as MockTestAction.updateAssessment:
            state.assessment = action.assessment
            
            case let action as MockTestAction.DismissTestBoard:
            state.assessment.feedback = action.feedback
            
            default:
                break
        }
        
        return state
    }
    
}
