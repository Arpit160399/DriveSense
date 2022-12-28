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
                    .map { _ -> UserSession in
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
                    .map { _ -> UserSession in
                        return session
                    }.eraseToAnyPublisher()
            }.eraseToAnyPublisher()
    }
    
    func signOut() -> AnyPublisher<Void, Error> {
        return userLocalStore.find(predicated: nil)
            .flatMap { (instructors: [InstructorModel]) -> AnyPublisher<Void,Error>  in
                let size = instructors.count
                guard size > 0 else {
                    return Just(Void())
                    .setFailureType(to: Error.self)
                    .eraseToAnyPublisher()
                }
                let initial = self.userLocalStore.remove(instructor: instructors[0])
                let task = instructors.dropFirst().reduce(initial) { combine,instructor  in
                    combine.merge(with: self.userLocalStore.remove(instructor: instructor))
                        .eraseToAnyPublisher()
                }
                return task.eraseToAnyPublisher()
            }.eraseToAnyPublisher()
    }
    
}
