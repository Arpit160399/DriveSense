//
//  Feedback.swift
//  DriveSense
//
//  Created by Arpit Singh on 03/09/22.
//

import Foundation

struct FeedbackModel: Codable , Equatable {
    var id: UUID
    var control: ControlModel?
    var judgement: JudgementModel?
    var junctions: JunctionsModel?
    var positioning: PositioningModel?
    var progress: ProgressModel?
    var useofSpeed: String?
    var followingDistance: String?
    var reversePark: String?
    var moveOff: MoveOffModel?
    var totalFaults: Double?
    var totalMajorFault: Double?
    var totalMinorFault: Double?
}
