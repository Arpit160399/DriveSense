//
//  DriveSenseSyncRemote.swift
//  DriveSense
//
//  Created by Arpit Singh on 01/09/22.
//

import Foundation
import Combine
class DriveSenseAssessmentRemoteApi: AssessmentRemoteApi {
    
    //MARK: - properties
    internal let session: Session
    private let networkSession: NetworkCall
    
    init(userSession: UserSession) {
        self.session = userSession.session
        networkSession = NetworkCall()
    }
    
    // MARK: - methods

    func getAssessmentFor(candidate: CandidatesModel) -> AnyPublisher<[AssessmentModel], NetworkError> {
        guard let request = try? NetworkRequest(url: SecuredRoute(endpoint: .assessment,
                                                      auth: session.accessToken,
                                                       id: candidate.id.uuidString),
                                     method: .get) else {
            return Fail(error: NetworkError.InvalidURl).eraseToAnyPublisher()
        }
        return networkSession.fetch(request)
    }

    func upload(assessment: AssessmentModel) -> AnyPublisher<AssessmentModel, NetworkError> {
        guard let request = try? NetworkRequest(url: SecuredRoute(
                                                endpoint: .assessment,
                                                auth: session.accessToken),
                                     method: .post,
                                     payload: assessment) else {
            return Fail(error: NetworkError.InvalidURl).eraseToAnyPublisher()
        }
        return networkSession.fetch(request)
    }

    func sendSensor(values: [SensorModel],for assessment: AssessmentModel ) -> AnyPublisher<[SensorModel], NetworkError> {
        let data = DataBinder(data: values)
        guard let request = try? NetworkRequest(url: SecuredRoute(endpoint: .sensor,
                                                auth: session.accessToken,
                                                id: assessment.id.uuidString),
                                     method: .post,
                                     payload: data) else {
            return Fail(error: NetworkError.InvalidURl).eraseToAnyPublisher()
        }
        return networkSession.fetch(request)
    }
}
