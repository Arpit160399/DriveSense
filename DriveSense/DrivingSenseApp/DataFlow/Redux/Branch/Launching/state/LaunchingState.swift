//
//  LaunchingState.swift
//  DriveSense
//
//  Created by Arpit Singh on 09/09/22.
//

import Foundation
struct LaunchingState: Equatable {

    var currentSessionState: AuthenticationState = .notSignedIn
    var errorPresent = Set<ErrorMessage>()
    
    static func == (lhs: LaunchingState, rhs: LaunchingState) -> Bool {
        return lhs.errorPresent == rhs.errorPresent
    }
}
