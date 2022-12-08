//
//  SettingsAction.swift
//  DriveSense
//
//  Created by Arpit Singh on 13/10/22.
//

import Foundation
struct SettingsAction: Action {
    
    struct FinishedWithError: Action {
        var error: ErrorMessage
    }
    
    struct PresentedError: Action {
        var error: ErrorMessage
    }
    
    struct SignOutInProgress: Action {}
   
}
