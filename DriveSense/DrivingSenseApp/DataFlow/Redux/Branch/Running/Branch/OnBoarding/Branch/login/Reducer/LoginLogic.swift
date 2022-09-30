//
//  LoginLogic.swift
//  DriveSense
//
//  Created by Arpit Singh on 14/09/22.
//

import Foundation
struct LoginLogic {
    
    static func signInOnProgress(for state: inout LoginStateView) {
        state.isEmailInputDisable = true
        state.isLoginButtonDisable = true
        state.isPasswordDisable = true
        state.isLoading = true
    }
    
    static func finishedWithAnError(for state: inout LoginStateView) {
        state.isLoading = false
        state.isEmailInputDisable = false
        state.isLoginButtonDisable = false
        state.isPasswordDisable = false
    }
    
}
