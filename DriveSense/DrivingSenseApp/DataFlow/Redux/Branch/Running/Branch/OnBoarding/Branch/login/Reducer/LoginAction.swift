//
//  LoginAction.swift
//  DriveSense
//
//  Created by Arpit Singh on 13/09/22.
//

import Foundation
struct LoginAction: Action {
    
    struct SignInOnProgress: Action {}
    
    struct SignInCompleted: OnBoardingCompeted {
        var user: UserSession
    }
    
    struct SignInErrorPresented: Action {
        var error: ErrorMessage
    }
    
    struct SignInFailedWithError: Action {
        var error: ErrorMessage
    }
}
