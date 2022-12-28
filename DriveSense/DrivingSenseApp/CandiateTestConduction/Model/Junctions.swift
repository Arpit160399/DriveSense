//
//  Junctions.swift
//  DriveSense
//
//  Created by Arpit Singh on 04/08/22.
//

import Foundation
struct Junctions: Equatable {
 var approachingSpeed: Conclusion
 var observation: Conclusion
 var turningRight: Conclusion
 var turningLeft: Conclusion
 var cutingCorner: Conclusion
   
}
extension Junctions {
    init() {
        approachingSpeed = .perfect
        observation = .perfect
        turningRight = .perfect
        turningLeft = .perfect
        cutingCorner = .perfect
    }
}

extension Junctions: faultNum {
    func totalFaultby(_ type: Conclusion) -> Int {
        return [approachingSpeed,observation,turningLeft,turningRight,cutingCorner]
            .reduce(0) { partialResult, current in
                return partialResult + current.getValue(type)
            }
    }
}
