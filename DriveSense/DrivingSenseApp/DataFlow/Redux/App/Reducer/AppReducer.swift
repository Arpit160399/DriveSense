//
//  AppReducer.swift
//  DriveSense
//
//  Created by Arpit Singh on 09/09/22.
//

import Foundation
extension  ReducerCollection {
  static let appReducer: Reducer<AppState> = { state , action in
      var state = state
      switch action {
         case let action as LaunchingAction.FinishedLaunching:
           let auth = action.authenticationState
           state = AppAction.state(for: auth)
          break
         case let action as LaunchingAction.FinishedWithPresentError:
            if case .launching(var launchingState) = state {
                launchingState.errorPresent.remove(action.error)
                if launchingState.errorPresent.count == 0 {
                    state = .running(.OnBoarding(.login(.init())))
                } else {
                    state = .launching(launchingState)
                }
           }
          break
       default :
             break
      }
      switch state {
         case .launching(let launchState):
          state = .launching(ReducerCollection.LaunchingReducer(launchState,
                                                                   action))
         case .running(let runningState):
          state = .running(ReducerCollection.runningReducer(runningState,
                                                               action))
     }
    return state
  }
}
