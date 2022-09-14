//
//  Reducer.swift
//  DriveSense
//
//  Created by Arpit Singh on 09/09/22.
//

import Foundation
extension ReducerCollection {
    
    static let LaunchingReducer: Reducer<LaunchingState> = { state, action in
        var newState = state
        switch action {
          case let action as LaunchingAction.FinishedWithAppError:
            newState.errorPresent.insert(action.error)
            newState.currentSessionState = .notSignedIn
          default:
              break
        }
        return newState
    }
    
}
