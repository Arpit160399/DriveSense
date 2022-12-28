//
//  RunningStateGetter.swift
//  DriveSense
//
//  Created by Arpit Singh on 14/09/22.
//

import Foundation
struct RunningStateGetter {
    
    var appStateGetter: (AppState) -> Optional<RunningState>
    
    init(_ stateGetter: @escaping (AppState) -> Optional<RunningState> ) {
        self.appStateGetter = stateGetter
    }
    
    
    func  signedInStateGetter(appState: AppState) -> Optional<SignedInState> {
        let runningState = appStateGetter(appState)
        guard case .value(let running) = runningState else {
            return .none
        }
        guard case .signIn(let signedInState) = running else {
            return .none
        }
        return .value(signedInState)
    }
    
    func onBoardingStateGetter(appState: AppState) -> Optional<OnBoardingState> {
        let runningOptional = appStateGetter(appState)
        guard case .value(let runningState) = runningOptional else {
            return .none
        }
        guard case .onBoarding(let onBoardingState) = runningState else {
            return .none
        }
        return .value(onBoardingState)
    }
    
}
