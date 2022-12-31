//
//  MockTestState.swift
//  DriveSense
//
//  Created by Arpit Singh on 13/10/22.
//

import Foundation
struct MockTestState: Equatable {
    
     var assessment: AssessmentModel
     var errorToPresent: Set<ErrorMessage>
     var startSensorCollection: Bool = false
     var viewState: MockTestViewState
     var currentSpeed: Double = 0
     var currentDirection: String = "Moving Forward"
     var currentDistance: Double = 0
     var loading = false
    
}

enum MockTestViewState: Equatable {
    case mainBoard
    case consentForm
    case initial
    case testBoard
}
