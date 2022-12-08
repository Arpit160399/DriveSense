//
//  AssessementDataLayer.swift
//  DriveSense
//
//  Created by Arpit Singh on 06/11/22.
//
import Combine
import Foundation
protocol AssessmentDataLayer {
    func getAssessment(page: Int) -> AnyPublisher<[AssessmentModel],Error>
    func update(feedback: FeedbackModel,forAssessment: AssessmentModel) -> AnyPublisher<FeedbackModel,Error>
    func collect(sensor: [SensorModel],
                 forAssessment: AssessmentModel) -> AnyPublisher<AssessmentModel,Error>
    func create(assessment: AssessmentModel) -> AnyPublisher<AssessmentModel,Error>
}
