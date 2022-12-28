//
//  Positioning.swift
//  DriveSense
//
//  Created by Arpit Singh on 04/08/22.
//

import Foundation
struct Positioning: Equatable {
    var normalDriving: Conclusion
    var laneDiscipline: Conclusion
}

extension Positioning: faultNum {
    func totalFaultby(_ type: Conclusion) -> Int {
        return normalDriving.getValue(type) + laneDiscipline.getValue(type)
    }
}

extension Positioning {
    init() {
        normalDriving = .perfect
        laneDiscipline = .perfect
    }
}
