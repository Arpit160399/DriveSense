//
//  ResponseBinder.swift
//  DriveSense
//
//  Created by Arpit Singh on 01/09/22.
//

import Foundation
struct DataBinder<T : Codable>: Codable {
    var data: T
}
