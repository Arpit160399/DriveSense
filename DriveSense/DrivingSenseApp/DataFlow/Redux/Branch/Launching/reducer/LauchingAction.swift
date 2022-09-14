//
//  LauchingAction.swift
//  DriveSense
//
//  Created by Arpit Singh on 09/09/22.
//

import Foundation
struct LaunchingAction: Action {
    
    struct FinishedLaunching: Action {
        let authenticationState: AuthenticationState
    }
    
    struct FinishedWithAppError: Action {
        let error: ErrorMessage
    }
    
    struct FinishedWithPresentError: Action {
        let error: ErrorMessage
    }
}
