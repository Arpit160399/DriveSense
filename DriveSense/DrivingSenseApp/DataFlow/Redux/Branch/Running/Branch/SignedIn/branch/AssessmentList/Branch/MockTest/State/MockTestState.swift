//
//  MockTestState.swift
//  DriveSense
//
//  Created by Arpit Singh on 13/10/22.
//

import Foundation
struct MockTestState {
     var candidate: CandidatesModel
     var assessment: AssessmentModel
     var errorToPresent: Set<ErrorMessage>
     var sensorData: [SensorModel]
     var viewState: MockTestViewState
}

enum MockTestViewState {
    case mainBoard
    case testBoard(TestBoardState)
}
