//
//  Conclusion.swift
//  DriveSense
//
//  Created by Arpit Singh on 26/07/22.
//

import Foundation
enum Conclusion: String {
  case Minor = "Minor Fault"
  case Major = "Major Fault"
  case Perfect = "Perfect"
}

extension Conclusion {
    
    static func get(_ value: String?) -> Conclusion {
        if let value = value {
            return Conclusion(rawValue: value) ?? .Perfect
        } else {
            return .Perfect
        }
    }
    
}
