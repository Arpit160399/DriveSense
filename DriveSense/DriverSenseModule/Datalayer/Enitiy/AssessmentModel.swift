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
}

