//
//  NetworkError.swift
//  DriveSense
//
//  Created by Arpit Singh on 31/08/22.
//

import Foundation

// Error Cases
enum NetworkError: Error {
    case NetworkFailure
    case ServerWith(ErrorResponse)
    case InvalidResponse(Error)
    case InvalidURl
}
