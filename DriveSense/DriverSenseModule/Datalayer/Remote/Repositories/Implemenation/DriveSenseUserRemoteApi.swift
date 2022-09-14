//
//  DriveSenseUserRemoteApi.swift
//  DriveSense
//
//  Created by Arpit Singh on 12/09/22.
//
import Combine
import Foundation
class DriveSenseUserRemoteApi: UserRemoteApi {
    
    //MARK: - properties
    internal let session: Session
    private let networkSession: NetworkCall
    
    init(session: Session) {
        self.session = session
        networkSession = NetworkCall()
    }
    
    func getUser() -> AnyPublisher<InstructorModel, NetworkError> {
        guard let request = try? NetworkRequest(url: SecuredRoute(endpoint: .user,
                                                       auth: session.accessToken),
                                     method: .get) else {
            return Fail(error: NetworkError.InvalidURl).eraseToAnyPublisher()
        }
        return networkSession.fetch(request)
    }
    
    
    func getCandidates() -> AnyPublisher<[CandidatesModel], NetworkError> {
        guard let request = try? NetworkRequest(url: SecuredRoute(endpoint: .candidates,
                                                       auth: session.accessToken),
                                     method: .get) else {
            return Fail(error: NetworkError.InvalidURl).eraseToAnyPublisher()
        }
        return networkSession.fetch(request)
    }
    
    func addNew(candidate: CandidatesModel) -> AnyPublisher<[CandidatesModel], NetworkError> {
        guard let request = try? NetworkRequest(url: SecuredRoute(endpoint: .candidates,
                                                       auth: session.accessToken),
                                     method: .post,
                                     payload: candidate) else {
            return Fail(error: NetworkError.InvalidURl).eraseToAnyPublisher()
        }
        return networkSession.fetch(request)
    }
}
