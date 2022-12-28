//
//  AssessmentEntity+CoreDataProperties.swift
//  DriveSense
//
//  Created by Arpit Singh on 31/08/22.
//
//

import Foundation

struct AssessmentModel: Codable,Identifiable {
    var id: UUID
    var totalDistance: Double?
    var avgSpeed: Double?
    var conductedBy: InstructorModel?
    var ofCandidate: CandidatesModel?
    var feedback: FeedbackModel?
    var sensor: [SensorModel]?
    var createdAt: Double?
    var endedAt: Double?
}

extension AssessmentModel: Hashable,Equatable {
    
    static func == (lhs: AssessmentModel, rhs: AssessmentModel) -> Bool {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
