//
//  AuthRemoteAPI.swift
//  DriveSense
//
//  Created by Arpit Singh on 31/08/22.
//
import Combine
import Foundation

 protocol AuthRemoteAPI {
     
     /// To authenticate the user with email and password
     /// - Parameter user: is model that created using email and password
     /// - Returns: a publisher notifies once the authentication is completed with either a user-session or an error if any occurred
    func signInRequest(for user: UserAuth) -> AnyPublisher<UserSession,NetworkError>
     
     /// To (register / add) a new instructor into the cloud service
     /// - Parameter instructor: is instructor model that will be registered
     /// - Returns: a publisher notifies once the authentication is completed with either a user-session or an error if any occurred
    func registration(as instructor: InstructorModel) -> AnyPublisher<UserSession,NetworkError>
}
