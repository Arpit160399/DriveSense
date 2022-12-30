//
//  JunctionsEntity+CoreDataProperties.swift
//  DriveSense
//
//  Created by Arpit Singh on 31/08/22.
//
//

import Foundation

struct JunctionsModel: Codable , Equatable {
    var approachingSpeed: String?
    var observation: String?
    var turingRight: String?
    var turingLeft: String?
    var cuttingCorner: String?
}
