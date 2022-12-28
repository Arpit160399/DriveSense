//
//  Judgement.swift
//  DriveSense
//
//  Created by Arpit Singh on 04/08/22.
//

import Foundation
struct Judgement: Equatable {
var overtaking: Conclusion
var meeting: Conclusion
var crossing: Conclusion
 
}
extension Judgement {
    init () {
        overtaking = .perfect
        meeting = .perfect
        crossing = .perfect
    }
}

extension Judgement: faultNum {
    func totalFaultby(_ type: Conclusion) -> Int {
        return [overtaking,meeting,crossing].reduce(0) { partialResult, current in
            return partialResult + current.getValue(type)
        }
    }
}
