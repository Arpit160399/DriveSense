//
//  DriveSenseRemoteAuth.swift
//  DriveSense
//
//  Created by Arpit Singh on 01/09/22.
//
import Combine
import Foundation
class DriveSenseRemoteAuth: AuthRemoteAPI {
    
    // MARK: - properties
    private var networkSession: NetworkCall
    private var sessionCoder: UserSessionCoding
    
    init() {
        networkSession = NetworkCall()
        sessionCoder = UserSessionPropertyListCoding()
    }
    
    // MARK: - method

    func signInRequest(for user: UserAuth) -> AnyPublisher<UserSession, NetworkError> {
       let sessionManager = KeychainUserSessionDataStore(coder: sessionCoder)
       guard let request = try? NetworkRequest(url: Route(.login),
                                               method: .post,
                                               payload: user) else {
           return Fail(error: NetworkError.invalidURl).eraseToAnyPublisher()
       }
        return networkSession.fetch(request).flatMap { session in
            return sessionManager.createSessionFor(user: session)
                .mapError { error in
                    return NetworkError.invalidResponse(error)
                }
        }.eraseToAnyPublisher()
    }
    
    func registration(as instructor: InstructorModel) -> AnyPublisher<UserSession, NetworkError> {
        let sessionManager = KeychainUserSessionDataStore(coder: sessionCoder)
        guard let request = try? NetworkRequest(url: Route(.registration),
                                                method: .post,
                                                payload: instructor) else {
            return Fail(error: NetworkError.invalidURl).eraseToAnyPublisher()
        }
        return networkSession.fetch(request).flatMap { session in
            return sessionManager.createSessionFor(user: session)
                .mapError { error in
                    return NetworkError.invalidResponse(error)
                }
        }.eraseToAnyPublisher()
    }

}
