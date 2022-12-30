//
//  SensorListAction.swift
//  DriveSense
//
//  Created by Arpit Singh on 13/10/22.
//

import Foundation
struct AssessmentDetailAction: Action {
  
    struct FetchedSensorValue: Action {
        var sensor: [SensorModel]
    }
    
    struct FetchingDataStarted: Action {}
    
    struct PresentError: Action {
        var error: ErrorMessage
    }
    
    struct PresentedError: Action {
        var error: ErrorMessage
    }
}
