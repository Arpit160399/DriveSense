//
//  InstructorPersistencelayer.swift
//  DriveSense
//
//  Created by Arpit Singh on 06/09/22.
//
import Combine
import Foundation
protocol InstructorPersistenceLayer {
    
    /// creates an Instructor Model object into Database.
    /// - Parameter instructor: the instructor model that need to be created.
    /// - Returns: a publisher that notifies once the Instructor model object is created and with response value as that object.
    func create(instructor: InstructorModel) -> AnyPublisher<InstructorModel,Error>
    
    /// fetch a particular instructor model object from the database.
    /// - Parameter id: the id of Model the need to fetched from the database.
    /// - Returns: a publisher which notifies once the fetch operation is completed with response value respected object model.
    func fetch(id: UUID) -> AnyPublisher<InstructorModel,Error>
    
    /// remove the particular instructor model from database.
    /// - Parameter instructor: instructor model that need to be removed from the database.
    /// - Returns: a publisher that notifies once remove operation is completed.
    func remove(instructor: InstructorModel) -> AnyPublisher<Void,Error>
}
