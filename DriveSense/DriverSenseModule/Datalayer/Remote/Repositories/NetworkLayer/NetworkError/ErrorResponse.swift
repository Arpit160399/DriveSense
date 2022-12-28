//
//  ErrorResponse.swift
//  DriveSense
//
//  Created by Arpit Singh on 31/08/22.
//

import Foundation
/// Modelling server error response into Entity
struct ErrorResponse: Codable {
    var message: String
    var status: String
}
