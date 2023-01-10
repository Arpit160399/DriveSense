//
//  DrivingState.swift
//  DriveSenseTests
//
//  Created by Arpit Singh on 30/12/22.
//
import Foundation

class DrivingState {

    private var prevSpeed: Double
    private var prevDirection: Double
//    private var isInReverse: Bool
    
    init(prevSpeed: Double = 0, prevDirection: Double = 0,isInReverse: Bool = false) {
        self.prevSpeed = prevSpeed
        self.prevDirection = prevDirection
    }
    
    
     func getTheDrivingState(direction: Double,speed: Double,course: Double) -> (direction: Direction, verdict: String) {
         
         let accelerationState = getAccelerationState(bySpeed: speed)
       
         let estimatedOffset: CGFloat = 10
        
         defer {
            prevDirection = direction
        }
         
        var currentDirection = Direction.movingForward
    
        if isConstant(direction: direction) {
            currentDirection = .movingForward
        } else if detectTheReverseDrivingIn(direction: direction) {
            currentDirection = .movingBackward
        } else if (checkForLeftTurn(direction: direction) ) {
            currentDirection = .leftTurn
//        } else if (course - direction) < (180 + estimatedOffset)
//                , (course - direction) > (180 - estimatedOffset) {
//            currentDirection = .movingBackward
        } else {
            currentDirection = .rightTurn
        }
        
        return (currentDirection, "\(currentDirection.rawValue) \(accelerationState)")
    }
    
    func detectTheReverseDrivingIn(direction: Double) -> Bool {
        let maxDegree: Double = 359
        var leftLimit = (Int(prevDirection) + 150) % Int(maxDegree)
        let rightLimit = (Int(prevDirection) + 210) % Int(maxDegree)
 
        while rightLimit != leftLimit {
            if Int(direction) == leftLimit {
                return true
            }
            leftLimit += 1
            if leftLimit > Int(maxDegree) {
                leftLimit = 0
            }
        }
        return false
    }

     func isConstant(direction: Double) -> Bool {
        
        let constantOffset = 30
        let maxDegree: Double = 359
        var leftLimit = Int(prevDirection)
        let rightLimit = (Int(prevDirection) + constantOffset) % Int(maxDegree)
        
        for _ in 0..<(constantOffset / 10) {
            leftLimit -= 10
            if leftLimit < 0 {
               leftLimit = Int(maxDegree) - 10
            }
        }
        while leftLimit != rightLimit {
            if Int(direction) == leftLimit {
                return true
            }
            
            leftLimit += 1
            
            if leftLimit > Int(maxDegree) {
                leftLimit = 0
            }
        }

        return false
    }
    
   func getAccelerationState(bySpeed: Double) -> String {
        let speedOffset: Double = 5
        defer {
            prevSpeed = bySpeed
        }
        if bySpeed > min(prevSpeed - speedOffset,0), bySpeed < (prevSpeed + speedOffset) {
            return "constant acceleration"
        } else if bySpeed > prevSpeed {
            return "increased acceleration"
        } else {
            return "decreased acceleration"
        }
    }
 
    func checkForLeftTurn(direction: Double) -> Bool {
        let maxDegree = 359
        var startRange = Int(prevDirection)
        var endRange = Int(prevDirection)
        for _ in 0..<18 {
            endRange -= 10
            if endRange < 0 {
                endRange = maxDegree - 10
            }
        }
        while startRange != endRange {
            if Int(direction) == startRange {
                return true
            }
            startRange -= 1
            if startRange < 0 {
                startRange = maxDegree
            }
        }
        return false
    }
}
