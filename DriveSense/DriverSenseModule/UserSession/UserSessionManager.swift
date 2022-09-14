//
//  UserSessionManager.swift
//  DriveSense
//
//  Created by Arpit Singh on 26/08/22.
//
import Combine
import Foundation
typealias Token = String

protocol UserSessionManager {
    func getUser() -> AnyPublisher<UserSession?,Error>
    func clearSession() -> AnyPublisher<Void,Error>
    func createSessionFor(user: UserSession) -> AnyPublisher<UserSession,Error>
}
