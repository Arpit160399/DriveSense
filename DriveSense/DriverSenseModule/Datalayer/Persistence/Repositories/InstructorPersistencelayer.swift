//
//  InstructorPersistencelayer.swift
//  DriveSense
//
//  Created by Arpit Singh on 06/09/22.
//
import Combine
import Foundation
protocol InstructorPersistenceLayer {
    
    /// Creates an Instructor Model object into Database.
    /// - Parameter instructor: the instructor model that need to be created.
    /// - Returns: a publisher that notifies once the Instructor model object is created and with response value as that object.
    func create(instructor: InstructorModel) -> AnyPublisher<InstructorModel,Error>
    
    /// Fetch a particular instructor model object from the database.
    /// - Parameter id: the id of Model the need to fetched from the database.
    /// - Returns: a publisher which notifies once the fetch operation is completed with response value respected object model.
    func fetch(id: UUID) -> AnyPublisher<InstructorModel,Error>
    
    /// To update Instructor model object value in the database.
    /// - Parameter feedback: the  feedback model with respected to which value needed to updated.
    /// - Returns: a publisher which notifies once the update operation is completed with new updated response object
    /// as response value.
    func update(instructor: InstructorModel) -> AnyPublisher<InstructorModel,Error>
    
    /// Finding a particular instructor model into database.
    /// - Parameter predicated: the query according to which the result will presented.
    /// - Returns: a publisher which notifies once the fetch operation is completed
    /// with response value respected object model.
    func find(predicated: NSPredicate) -> AnyPublisher<InstructorModel?,Error>
    
    /// Remove the particular instructor model from database.
    /// - Parameter instructor: instructor model that need to be removed from the database.
    /// - Returns: a publisher that notifies once remove operation is completed.
    func remove(instructor: InstructorModel) -> AnyPublisher<Void,Error>
}
