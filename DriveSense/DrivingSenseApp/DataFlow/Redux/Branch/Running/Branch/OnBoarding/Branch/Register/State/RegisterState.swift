//
//  RegisterState.swift
//  DriveSense
//
//  Created by Arpit Singh on 14/09/22.
//

import Foundation
struct RegisterState: Equatable {
    var isLoading = false
    var errorToPresent = Set<ErrorMessage>()
}
