//
//  SettingsReducer.swift
//  DriveSense
//
//  Created by Arpit Singh on 13/10/22.
//

import Foundation
extension ReducerCollection {
    
    static let SettingReducer: Reducer<SettingsState> = { state, action in
        var state = state
        switch action {
        case let action as SettingsAction.FinishedWithError:
            state.errorPresent.remove(action.error)
        case let action as SettingsAction.SignOutInProgress:
            state.loading = true
        case let action as SettingsAction.PresentedError:
            state.errorPresent.insert(action.error)
        case let action as SettingsAction:
            break 
        default:
            break
        }
        return state
    }
    
}
