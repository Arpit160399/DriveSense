//
//  OnBoardinActions.swift
//  DriveSense
//
//  Created by Arpit Singh on 12/09/22.
//

import Foundation
struct OnBoardingActions: Action {
    
    struct GoToSignIn: Action {}
    
    struct GoToSignUp: Action {}
}

protocol OnBoardingCompeted: Action {
    var user: UserSession { get }
}
