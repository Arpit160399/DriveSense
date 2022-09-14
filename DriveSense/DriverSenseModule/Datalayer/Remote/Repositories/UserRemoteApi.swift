//
//  UserRemoteApi.swift
//  DriveSense
//
//  Created by Arpit Singh on 12/09/22.
//
import Combine
import Foundation
protocol UserRemoteApi {
    
    /// reference of currently logged in user session.
    var session: Session { get }
    
    /// To get current user from the session.
    /// - Returns: a publisher notifies once the operation is completed with either
    ///  a instructor model or an error if any occurred.
    func getUser() -> AnyPublisher<InstructorModel,NetworkError>
    
    /// To fetch all candidates enrolled with current user.
    /// - Returns: a publisher notifies once the operation is completed with either
    ///  a collection of candidates model or an error if any occurred.
    func getCandidates() -> AnyPublisher<[CandidatesModel],NetworkError>
    
    /// To enrol new student.
    /// - Parameter candidate: the candidate mode that is to be upload to server.
    /// - Returns: a publisher notifies once the operation is completed with either
    ///  new collection of candidates model or an error if any occurred.
    func addNew(candidate: CandidatesModel) ->  AnyPublisher<[CandidatesModel],NetworkError>
}
