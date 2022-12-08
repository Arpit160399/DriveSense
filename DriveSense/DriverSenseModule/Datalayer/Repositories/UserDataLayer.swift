//
//  InstructorDataLayer.swift
//  DriveSense
//
//  Created by Arpit Singh on 07/11/22.
//
import Combine
import Foundation
protocol UserDataLayer {
    func signIn(user: UserAuth) -> AnyPublisher<UserSession,Error>
    func register(asInstructor: InstructorModel) -> AnyPublisher<UserSession,Error>
    func signOut(asInstructor: InstructorModel) -> AnyPublisher<Void,Error>
}
