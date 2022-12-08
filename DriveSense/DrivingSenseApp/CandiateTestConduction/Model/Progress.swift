//
//  Progress.swift
//  DriveSense
//
//  Created by Arpit Singh on 04/08/22.
//

import Foundation
struct Progress {
 var appropriatedSpeed: Conclusion
 var undueHesitation: Conclusion
   
}

extension Progress {
    init() {
        appropriatedSpeed = .Perfect
        undueHesitation = .Perfect
    }
}
