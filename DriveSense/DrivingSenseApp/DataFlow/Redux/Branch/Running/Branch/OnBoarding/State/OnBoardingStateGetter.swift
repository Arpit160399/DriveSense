//
//  OnBoardingStateGetter.swift
//  DriveSense
//
//  Created by Arpit Singh on 14/09/22.
//

import Foundation
struct OnBoardingStateGetter {
    
    let runningStateGetter: (AppState) -> Optional<OnBoardingState>
    
    init(_ stateGetter: @escaping (AppState) -> Optional<OnBoardingState>) {
        self.runningStateGetter = stateGetter
    }
    
    func loginStateGetter(appState: AppState) -> Optional<LoginState>  {
        let optionalState = runningStateGetter(appState)
        guard case .value(let runningState) = optionalState else {
            return .none
        }
        guard case .login(let loginState) = runningState else {
            return .none
        }
        return .value(loginState)
    }
    
    
    func registerStateGetter(appState: AppState) -> Optional<RegisterState> {
        let optionalState = runningStateGetter(appState)
        guard case .value(let runningState) = optionalState else {
            return .none
        }
        guard case .register(let registerState) = runningState else {
            return .none
        }
        return .value(registerState)
    }
    
}
