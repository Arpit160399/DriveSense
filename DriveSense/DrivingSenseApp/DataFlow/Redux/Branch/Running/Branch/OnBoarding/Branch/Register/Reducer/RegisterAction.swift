//
//  RegisterAction.swift
//  DriveSense
//
//  Created by Arpit Singh on 14/09/22.
//

import Foundation
struct RegisterAction: Action {
    
    struct RegisterInProgress: Action {}
    
    struct RegisterCompleted: OnBoardingCompeted {
        let user: UserSession
    }
    
    struct RegistrationFailedWithError: Action {
        let error: ErrorMessage
    }
    
    struct RegistrationErrorPresented: Action {
        let error: ErrorMessage
    }
}
