//
//  LoginView.swift
//  DriveSense
//
//  Created by Arpit Singh on 30/07/22.
//

import Foundation
class LoginViewModel: ObservableObject {
    @Published var user: SignInUser
    @Published var loading = false
    @Published var error = ""
    @Published var type = LoginTypeError.none
    @Published var navigation = NavigationModel.none
    
    enum LoginTypeError {
        case invalidUserName
        case invalidPassword
        case serverRespons
        case none
    }
    
    init () {
        user = .init()
    }
    
    //MARK: perfrom Login Action
    func loginUser() {
        
    }
    
}
struct SignInUser {
    var email = ""
    var password = ""
}

