//
//  AppStateGetter.swift
//  DriveSense
//
//  Created by Arpit Singh on 09/09/22.
//

import Foundation

enum Optional <T: Equatable>: Equatable {
    case value(T)
    case none
}

struct AppStateGetter {
    
    public func getLaunchViewState(appState: AppState) -> Optional<LaunchingState> {
      switch appState {
      case .launching(let launchState):
          return .value(launchState)
      default:
          return .none
      }
    }

    public func getAppRunningState(appState: AppState) -> Optional<RunningState> {
      switch appState {
      case .running(let appRunningState):
          return .value(appRunningState)
      default:
          return .none
      }
    }
    
}

// S
