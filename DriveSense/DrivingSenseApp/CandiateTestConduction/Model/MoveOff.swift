//
//  MoveOff.swift
//  DriveSense
//
//  Created by Arpit Singh on 04/08/22.
//

import Foundation
struct MoveOff {
var safety: Conclusion
var control: Conclusion
}

extension MoveOff {
    init() {
        safety = .Perfect
        control = .Perfect
    }
}
