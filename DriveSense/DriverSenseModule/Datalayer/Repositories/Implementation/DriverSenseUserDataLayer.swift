//
//  DriverSenseUserDataLayer.swift
//  DriveSense
//
//  Created by Arpit Singh on 07/11/22.
//
import Combine
import Foundation
class DriverSenseUserDataLayer: UserDataLayer {
    
    private let remoteApi: AuthRemoteAPI
    private let userLocalStore: InstructorPersistenceLayer
    
    init(remoteApi: AuthRemoteAPI,
         instructorCache: InstructorPersistenceLayer) {
        self.remoteApi = remoteApi
        self.userLocalStore = instructorCache
    }
    
    
    func signIn(user: UserAuth) -> AnyPublisher<UserSession, Error> {
        return remoteApi
            .signInRequest(for: user)
            .mapError({ $0 as Error })
            .flatMap({ (session: UserSession) -> AnyPublisher<UserSession, Error> in
                return self.userLocalStore.create(instructor: session.user)
                    .map { model -> UserSession in
                        return session
                    }.eraseToAnyPublisher()
            }).eraseToAnyPublisher()
    }
    
    func register(asInstructor: InstructorModel) -> AnyPublisher<UserSession, Error> {
        return remoteApi
            .registration(as: asInstructor)
            .mapError({ $0 as Error })
            .flatMap { (session: UserSession) -> AnyPublisher<UserSession,Error> in
                return self.userLocalStore.create(instructor: session.user)
                    .map { model -> UserSession in
                        return session
                    }.eraseToAnyPublisher()
            }.eraseToAnyPublisher()
    }
    
    func signOut(asInstructor: InstructorModel) -> AnyPublisher<Void, Error> {
        return userLocalStore.remove(instructor: asInstructor)
    }
    
}
