//
//  AppStateGetter.swift
//  DriveSense
//
//  Created by Arpit Singh on 09/09/22.
//

import Foundation
struct AppStateGetter {
    
   
    public func getLaunchViewState(appState: AppState) -> LaunchingState {
      switch appState {
      case .launching(let launchState):
        return launchState
      default:
          return LaunchingState()
      }
    }

    public func getAppRunningState(appState: AppState) -> RunningState {
      switch appState {
      case .running(let appRunningState):
          return appRunningState
      default:
          return RunningState.OnBoarding(.login(LoginState()))
      }
    }
    
}
