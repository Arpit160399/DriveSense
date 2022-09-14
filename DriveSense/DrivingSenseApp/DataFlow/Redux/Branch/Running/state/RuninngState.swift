//
//  RuninngState.swift
//  DriveSense
//
//  Created by Arpit Singh on 09/09/22.
//

import Foundation
enum RunningState: Equatable {
    case OnBoarding(OnBoardingState)
    case SignIn(SignedInState)
}
