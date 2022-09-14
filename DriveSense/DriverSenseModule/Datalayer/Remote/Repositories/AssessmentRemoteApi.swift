//
//  AssessmentRemoteApi.swift
//  DriveSense
//
//  Created by Arpit Singh on 31/08/22.
//

import Foundation
import Combine
protocol AssessmentRemoteApi {
    
    /// reference of currently logged in user session.
    var session: Session { get }
        
    /// To get all feedback of driving on given candidate provided by current user.
    /// - Parameter candidate: candidate model for which all feedback needed to fetch.
    /// - Returns: a publisher notifies once the operation is completed with either
    ///  a assessment model or an error if any occurred.
    func getAssessmentFor(candidate: CandidatesModel) -> AnyPublisher<[AssessmentModel],NetworkError>
   
    /// To sync the given driving feedback into the cloud.
    /// - Parameter assessment: the assessment that is to be uploaded to server.
    /// - Returns: a publisher notifies once the operation is completed with either
    ///  a assessment model or an error if any occurred.
    func upload(assessment: AssessmentModel) -> AnyPublisher<AssessmentModel,NetworkError>
    
    /// To sync the sensor values that was collected during the mock test.
    /// - Parameters:
    ///   - values: is collection of sensor value that is to be upload to server.
    ///   - assessment: the assessment for which the sensor values need to be uploaded for.
    /// - Returns: a publisher notifies once the operation is completed with either
    ///  new collection of sensor model or an error if any occurred.
    func sendSensor(values: [SensorModel],for assessment: AssessmentModel) -> AnyPublisher<[SensorModel],NetworkError>
}
