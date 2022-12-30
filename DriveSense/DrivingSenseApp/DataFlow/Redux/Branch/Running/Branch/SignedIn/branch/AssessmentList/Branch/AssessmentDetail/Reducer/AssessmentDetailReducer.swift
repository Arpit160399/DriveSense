//
//  SensorListReducer.swift
//  DriveSense
//
//  Created by Arpit Singh on 13/10/22.
//

import Foundation
extension ReducerCollection {
    static let AssessmentDetailReducer: Reducer<AssessmentDetailState> = {  state, action in
        var state = state
        
        switch action {
        case let action as AssessmentDetailAction.FetchedSensorValue:
            let places = action.sensor
                .map({ IdentifiablePlace(lat: $0.gps?.latitude ?? 0.0,
                                         long:  $0.gps?.longitude ?? 0.0)})
            state.places.append(contentsOf: places)
            state.loading = false
        case let action as AssessmentDetailAction.FetchingDataStarted:
            state.loading = true
        case let action as AssessmentDetailAction.PresentError:
            state.errorToPresent.insert(action.error)
        case let action as AssessmentDetailAction.PresentedError:
            state.errorToPresent.remove(action.error)
            state.loading = false
        default:
            break
        }
        
        return state
    }
}
