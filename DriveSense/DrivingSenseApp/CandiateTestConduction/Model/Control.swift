//
//  Control.swift
//  DriveSense
//
//  Created by Arpit Singh on 04/08/22.
//

import Foundation
struct Control {
 var acceleation:Conculsion
 var footBreak: Conculsion
 var steering: Conculsion
 var parkingBreak: Conculsion
 var clutch: Conculsion
 var gear: Conculsion
    init() {
        acceleation = .Perfect
        footBreak = .Perfect
        steering = .Perfect
        parkingBreak = .Perfect
        clutch = .Perfect
        gear = .Perfect
    }
}
