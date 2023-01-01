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
     var testOperation: TestOperation = .none
     var viewState: MockTestViewState
     var currentSpeed: Double = 0
     var currentDirection: String = "Moving Forward"
     var currentDistance: Double = 0
     var loading = false
    
}

enum TestOperation: Equatable {
    case none
    case startSensorCollection
    case savingFeedback
}

enum MockTestViewState: Equatable {
    case mainBoard
    case consentForm
    case initial
    case testBoard
}
