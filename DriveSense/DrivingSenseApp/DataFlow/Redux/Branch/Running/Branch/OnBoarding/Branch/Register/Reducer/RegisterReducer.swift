//
//  RegisterReducer.swift
//  DriveSense
//
//  Created by Arpit Singh on 14/09/22.
//

import Foundation
extension ReducerCollection {
    static let RegisterReducer: Reducer<RegisterState> = { state, action in
        var state = state
        switch action {
        case let action as RegisterAction.RegisterInProgress:
            state.isLoading = true
        case let action as RegisterAction.RegistrationFailedWithError:
            state.errorToPresent.insert(action.error)
        case let action as RegisterAction.RegistrationErrorPresented:
            state.errorToPresent.remove(action.error)
            state.isLoading = false
        default:
            break
        }
        return state
    }
}
