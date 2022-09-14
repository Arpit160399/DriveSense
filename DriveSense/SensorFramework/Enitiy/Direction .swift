//
//  Direction .swift
//  DriveSense
//
//  Created by Arpit Singh on 19/08/22.
//

import Foundation
public enum Direction: String {
    case leftTurn = "Left Turn"
    case rightTurn = "Right Turn"
    case movingForward = "Moving Forward"
    case movingBackward = "Moving Backward"
    
    func  degree() -> Double {
        return 0
    }
}
