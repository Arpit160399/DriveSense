//
//  AuthenticationState.swift
//  DriveSense
//
//  Created by Arpit Singh on 09/09/22.
//

import Foundation
enum AuthenticationState {
    case notSignedIn
    case signedIn(UserSession)
    case notVerified(UserSession)
    
    init(session: UserSession?) {
        if let userSession =  session {
            self = .notVerified(userSession)
        } else {
            self = .notSignedIn
        }
    }
}
