//
//  Conclusion.swift
//  DriveSense
//
//  Created by Arpit Singh on 26/07/22.
//

import Foundation
enum Conclusion: String,Equatable {
  case minor = "Minor Fault"
  case major = "Major Fault"
  case perfect = "Perfect"
}

extension Conclusion {
    
    static func get(_ value: String?) -> Conclusion {
        if let value = value {
            return Conclusion(rawValue: value) ?? .perfect
        } else {
            return .perfect
        }
    }
    
    func getValue(_ by: Conclusion) -> Int{
        return self == by ? 1 : 0
    }
    
}
