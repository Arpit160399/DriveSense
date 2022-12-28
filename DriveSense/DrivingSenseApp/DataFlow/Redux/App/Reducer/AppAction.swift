//
//  AppAction.swift
//  DriveSense
//
//  Created by Arpit Singh on 09/09/22.
//

import Foundation
struct AppAction {
    static func state(for authState: AuthenticationState) -> AppState {
        switch authState {
            case .notSignedIn:
                return AppState.running(.onBoarding(.login(LoginState())))
            case .notVerified(let userSession):
                let session = userSession
                return AppState
                    .launching(.init(currentSessionState: .notVerified(session),
                                     errorPresent: []))
            case .signedIn(let userSession):
                return AppState
                    .running(.signIn(.init(userSession: userSession, candidatesViewState: .candidateList)))
        }
    }
}
