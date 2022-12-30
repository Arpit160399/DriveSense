//
//  ControlEntity+CoreDataProperties.swift
//  DriveSense
//
//  Created by Arpit Singh on 31/08/22.
//
//


import Foundation
struct ControlModel: Codable, Equatable {
    var acceleration: String
    var footBreak: String
    var steering: String
    var parkingBreak: String
    var clutch: String
    var gear: String
}
