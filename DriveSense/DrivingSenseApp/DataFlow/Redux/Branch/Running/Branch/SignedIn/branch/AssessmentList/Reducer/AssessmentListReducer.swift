//
//  AssessmentListReducer.swift
//  DriveSense
//
//  Created by Arpit Singh on 10/10/22.
//

import Foundation
extension ReducerCollection {
    static let AssessmentListReducer: Reducer<AssessmentListState> = { state ,action in
        var state = state
        switch action {
        case let action as AssessmentListAction.PresentSensorData:
            state.viewState = .SensorData(.init())
        case let action as AssessmentListAction.PresentMockTesting:
            state.viewState = .MockTest(.init(candidate: action.candidate,
                                              assessment: .init(id: UUID()),
                                              errorToPresent: Set<ErrorMessage>(),
                                              sensorData: [], viewState: .mainBoard))
        default:
          state = AssessmentListLogic.setState(current: state, action: action)
        }
        switch state.viewState {
            case .MockTest(let mockState):
            state.viewState = .MockTest(ReducerCollection.MockTestReducer(mockState,action))
            case .SensorData(let sensorState):
            state.viewState = .SensorData(ReducerCollection.SensorListReducer(sensorState,action))
            default:
                break
        }
        return state
    }
}
