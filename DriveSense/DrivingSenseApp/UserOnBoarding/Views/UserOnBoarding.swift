//
//  UserOnBoarding.swift
//  DriveSense
//
//  Created by Arpit Singh on 31/07/22.
//

import SwiftUI

struct UserOnBoarding: View {
    @State var currentUserNeedTo: UserOnBoardingState
    @ObservedObject var loginViewModel: LoginViewModel
    @ObservedObject var registrationViewModel: RegistrationViewModel
    enum UserOnBoardingState {
        case Login
        case Registration
    }
    var body: some View {
        switch currentUserNeedTo {
        case .Login :
             Login(stateCurrent: $currentUserNeedTo,
                viewModel: loginViewModel)
        case .Registration:
              Registration(stateCurrent: $currentUserNeedTo,
                viewModel: registrationViewModel)
        }
    }
}

struct UserOnBoarding_Previews: PreviewProvider {
    static var previews: some View {
        UserOnBoarding(currentUserNeedTo: .Login, loginViewModel: LoginViewModel(), registrationViewModel: RegistrationViewModel())
    }
}
