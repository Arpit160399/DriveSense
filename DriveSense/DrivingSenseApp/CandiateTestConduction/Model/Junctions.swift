//
//  Junctions.swift
//  DriveSense
//
//  Created by Arpit Singh on 04/08/22.
//

import Foundation
struct Junctions {
 var approachingSpeed: Conculsion
 var observation: Conculsion
 var turningRight: Conculsion
 var turningLeft: Conculsion
 var cutingCorner: Conculsion
    init() {
        approachingSpeed = .Perfect
        observation = .Perfect
        turningRight = .Perfect
        turningLeft = .Perfect
        cutingCorner = .Perfect
    }
}
