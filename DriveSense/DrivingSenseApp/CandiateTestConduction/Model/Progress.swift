//
//  Progress.swift
//  DriveSense
//
//  Created by Arpit Singh on 04/08/22.
//

import Foundation
struct Progress: Equatable {
 var appropriatedSpeed: Conclusion
 var undueHesitation: Conclusion
}

extension Progress: faultNum {
    func totalFaultby(_ type: Conclusion) -> Int {
        return appropriatedSpeed.getValue(type) + undueHesitation.getValue(type)
    }
}

extension Progress {
    init() {
        appropriatedSpeed = .perfect
        undueHesitation = .perfect
    }
}
