//
//  Judgement.swift
//  DriveSense
//
//  Created by Arpit Singh on 04/08/22.
//

import Foundation
struct Judgement {
var overtaking: Conclusion
var meeting: Conclusion
var crossing: Conclusion
 
}
extension Judgement {
    init () {
        overtaking = .Perfect
        meeting = .Perfect
        crossing = .Perfect
    }
}
