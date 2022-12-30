//
//  CandidatesEntity+CoreDataProperties.swift
//  DriveSense
//
//  Created by Arpit Singh on 31/08/22.
//
//

import Foundation

struct CandidatesModel:Equatable, Identifiable , Codable {
 
    var id: UUID
    var name: String?
    var dateOfBirth: Double?
    var address: String?
    var createdAt: Double?
    var instructor: InstructorModel?
    var assessment: [AssessmentModel]?
    
}

extension CandidatesModel: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
