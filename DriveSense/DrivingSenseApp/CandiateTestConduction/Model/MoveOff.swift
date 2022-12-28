//
//  MoveOff.swift
//  DriveSense
//
//  Created by Arpit Singh on 04/08/22.
//

import Foundation
struct MoveOff: Equatable {
var safety: Conclusion
var control: Conclusion
}

extension MoveOff {
    init() {
        safety = .perfect
        control = .perfect
    }
}

extension MoveOff: faultNum {
    func totalFaultby(_ type: Conclusion) -> Int {
        return safety.getValue(type) + control.getValue(type)
    }
}
