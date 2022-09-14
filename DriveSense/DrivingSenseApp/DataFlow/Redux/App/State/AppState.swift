//
//  AppState.swift
//  DriveSense
//
//  Created by Arpit Singh on 09/09/22.
//

import Foundation
enum AppState: Equatable {    
    case launching(LaunchingState)
    case running(RunningState)
}
