//
//  File.swift
//  DriveSense
//
//  Created by Arpit Singh on 26/07/22.
//

import Foundation
struct TestMark {
 var TotalMinorFault: Int
 var TotalMajorFault: Int
 var useofSpeed: Conculsion
 var followingDistance: Conculsion
 var reversePark: Conculsion
 var progress: Progress
 var control: Control
 var moveOff: MoveOff
 var junctions: Junctions
 var positioning: Positioning
 var judgement: Judgement
    init() {
        TotalMajorFault = 0
        TotalMinorFault = 0
        useofSpeed = .Perfect
        followingDistance = .Perfect
        reversePark = .Perfect
        progress = .init()
        control = .init()
        moveOff = .init()
        junctions = .init()
        positioning = .init()
        judgement = .init()
    }
}
