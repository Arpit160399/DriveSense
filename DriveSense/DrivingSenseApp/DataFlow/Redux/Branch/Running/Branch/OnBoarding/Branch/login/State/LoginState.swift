//
//  SiginStateView.swift
//  DriveSense
//
//  Created by Arpit Singh on 13/09/22.
//

import Foundation
struct LoginState: Equatable {
    
    var viewState = LoginStateView()
    
    var errorsToShow = Set<ErrorMessage>()
    
}

struct LoginStateView: Equatable {
    
    var isEmailInputDisable = false
    var isPasswordDisable = false
    var isLoginButtonDisable = false
    var isLoading = false
    
    
}
