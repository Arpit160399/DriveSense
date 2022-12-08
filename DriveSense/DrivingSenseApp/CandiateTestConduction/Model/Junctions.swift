//
//  Junctions.swift
//  DriveSense
//
//  Created by Arpit Singh on 04/08/22.
//

import Foundation
struct Junctions {
 var approachingSpeed: Conclusion
 var observation: Conclusion
 var turningRight: Conclusion
 var turningLeft: Conclusion
 var cutingCorner: Conclusion
   
}
extension Junctions {
    init() {
        approachingSpeed = .Perfect
        observation = .Perfect
        turningRight = .Perfect
        turningLeft = .Perfect
        cutingCorner = .Perfect
    }
}
