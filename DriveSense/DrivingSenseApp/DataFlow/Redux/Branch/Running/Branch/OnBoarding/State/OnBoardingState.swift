//
//  OnBoardingState.swift
//  DriveSense
//
//  Created by Arpit Singh on 09/09/22.
//

import Foundation
enum OnBoardingState: Equatable {
    case login(LoginState)
    case register
}
