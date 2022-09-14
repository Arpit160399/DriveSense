//
//  ErrorMessage.swift
//  DriveSense
//
//  Created by Arpit Singh on 09/09/22.
//

import Foundation
struct ErrorMessage:Identifiable,Hashable,Error {
    let id = UUID()
    var title: String
    var message: String
}
