//
//  NetworkError.swift
//  DriveSense
//
//  Created by Arpit Singh on 31/08/22.
//

import Foundation

/// Error Cases
enum NetworkError: Error {
    case networkFailure
    case serverWith(ErrorResponse)
    case invalidResponse(Error)
    case invalidURl
}
