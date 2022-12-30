//
//  SensorListState.swift
//  DriveSense
//
//  Created by Arpit Singh on 13/10/22.
//

import Foundation
struct AssessmentDetailState: Equatable {
    var loading = false
    var assessment: AssessmentModel
    var places: [IdentifiablePlace]
    var errorToPresent: Set<ErrorMessage>
}
