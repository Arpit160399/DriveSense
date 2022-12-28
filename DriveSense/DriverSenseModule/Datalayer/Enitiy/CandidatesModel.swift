//
//  CandidatesEntity+CoreDataProperties.swift
//  DriveSense
//
//  Created by Arpit Singh on 31/08/22.
//
//

import Foundation

struct CandidatesModel:Equatable, Identifiable , Codable  {
 
    
    var id: UUID
    var name: String?
    var dateOfBirth: Double?
    var address: String?
    var createdAt: Double?
    var instructor: InstructorModel?
    var assessment: [AssessmentModel]?
    
    static func == (lhs: CandidatesModel, rhs: CandidatesModel) -> Bool {
        return lhs.id == rhs.id
    }
}

extension CandidatesModel: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
