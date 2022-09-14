//
//  CandidatesEntity+CoreDataProperties.swift
//  DriveSense
//
//  Created by Arpit Singh on 31/08/22.
//
//

import Foundation

struct CandidatesModel: Identifiable , Codable  {
    var id: UUID
    var name: String?
    var dateOfBirth: Double?
    var address: String?
    var instructor: InstructorModel?
    var assessment: [AssessmentModel]?
}

