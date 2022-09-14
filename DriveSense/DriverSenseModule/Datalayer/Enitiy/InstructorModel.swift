//
//  InstructorEntity+CoreDataProperties.swift
//  DriveSense
//
//  Created by Arpit Singh on 31/08/22.
//
//

import Foundation

public struct InstructorModel: Identifiable, Codable, Equatable {
    public var id: UUID
    var name: String?
    var email: String?
    var postcode: String?
    var address: String?
    var adi: ADIModel?
    var students: [CandidatesModel]?
    var password: String?
    
    public static func == (lhs: InstructorModel, rhs: InstructorModel) -> Bool {
        return lhs.id == rhs.id
    }
}

